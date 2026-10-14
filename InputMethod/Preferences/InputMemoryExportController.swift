import AppKit
import SwiftUI
import Combine
import UniformTypeIdentifiers
import CommonExtensions

/// Retained independently of the selected preferences page, including on macOS 13.
@MainActor
final class InputMemoryExportController: ObservableObject {

        static let shared = InputMemoryExportController()
        @Published private(set) var isExporting: Bool = false
        @Published var feedback: Feedback?
        private var operation: Task<Void, Never>?

        struct Feedback {
                let message: LocalizedStringResource
        }

        private enum Phase {
                case preparation
                case export
                case publication
        }

        private init() {}

        func start() {
                guard isExporting.negative else { return }
                isExporting = true
                feedback = nil
                operation = Task {
                        defer {
                                isExporting = false
                                operation = nil
                        }
                        guard let destination = await selectDestination() else { return }
                        let scoped = destination.startAccessingSecurityScopedResource()
                        defer { if scoped { destination.stopAccessingSecurityScopedResource() } }
                        var phase = Phase.preparation
                        do {
                                try InputMemoryExporter.protectSource(source: InputMemory.databaseURL, destination: destination)
                                try await InputMemory.waitUntilReady()
                                phase = .export
                                let count = try await export(to: destination) { phase = .publication }
                                feedback = Feedback(message: LocalizedStringResource("InputMemorySettingsView.ExportInputMemory.Success \(count)", comment: "Export confirmation; the variable is the number of learned entries saved."))
                        } catch is CancellationError {
                                // Cancellation does not report a failure or publish a partial file.
                        } catch MemorySQLiteError.protectedDestination {
                                feedback = Feedback(message: "InputMemorySettingsView.ExportInputMemory.ProtectedDestination")
                        } catch MemorySQLiteError.timedOut {
                                feedback = Feedback(message: "InputMemorySettingsView.ExportInputMemory.SourceBusy")
                        } catch MemorySQLiteError.invalidFormat where phase == .export {
                                feedback = Feedback(message: "InputMemorySettingsView.ExportInputMemory.ValidationFailed")
                        } catch {
                                switch phase {
                                case .preparation:
                                        feedback = Feedback(message: "InputMemorySettingsView.ExportInputMemory.PreparationFailed")
                                case .export:
                                        feedback = Feedback(message: "InputMemorySettingsView.ExportInputMemory.ExportFailed")
                                case .publication:
                                        feedback = Feedback(message: "InputMemorySettingsView.ExportInputMemory.WriteFailed")
                                }
                        }
                }
        }

        private func selectDestination() async -> URL? {
                let panel = NSSavePanel()
                panel.allowedContentTypes = [UTType(filenameExtension: "sqlite3") ?? .database]
                panel.canCreateDirectories = true
                let formatter = DateFormatter()
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = .current
                formatter.dateFormat = "yyyyMMdd-HHmmss"
                let dateText: String = formatter.string(from: .now)
                panel.nameFieldStringValue = "memory-\(dateText).sqlite3"

                // Closing preferences while the sheet is open behaves like Cancel.
                let observer = NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: SettingsWindow.shared, queue: .main) { _ in
                        MainActor.assumeIsolated { panel.cancel(nil) }
                }
                defer { NotificationCenter.default.removeObserver(observer) }
                return await withCheckedContinuation { continuation in
                        panel.beginSheetModal(for: SettingsWindow.shared) { response in
                                continuation.resume(returning: response == .OK ? panel.url : nil)
                        }
                }
        }

        private func export(to destination: URL, willPublish: () -> Void) async throws -> Int64 {
                let workspace = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
                try FileManager.default.createDirectory(at: workspace, withIntermediateDirectories: false)
                defer { try? FileManager.default.removeItem(at: workspace) }
                let output = workspace.appendingPathComponent("export.sqlite3")
                let source = InputMemory.databaseURL
                let exportTask = Task.detached(priority: .utility) {
                        try InputMemoryExporter.export(source: source, output: output)
                }
                let count = try await withTaskCancellationHandler {
                        try await exportTask.value
                } onCancel: {
                        exportTask.cancel()
                }
                try Task.checkCancellation()
                willPublish()
                let publishTask = Task.detached(priority: .utility) {
                        try InputMemoryExporter.publish(output: output, destination: destination, source: source)
                }
                try await withTaskCancellationHandler {
                        try await publishTask.value
                } onCancel: {
                        publishTask.cancel()
                }
                return count
        }
}
