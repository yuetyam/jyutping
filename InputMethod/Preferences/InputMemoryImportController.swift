import AppKit
import SwiftUI
import Combine
import UniformTypeIdentifiers
import SQLite3
import CommonExtensions
import SQLiteWrapper

/// Retained independently of the selected preferences page to preserve import state across sidebar navigation.
@MainActor
final class InputMemoryImportController: ObservableObject {

        static let shared = InputMemoryImportController()
        @Published private(set) var isImporting: Bool = false
        @Published var feedback: Feedback?
        private var operation: Task<Void, Never>?

        struct Feedback {
                let message: LocalizedStringResource
        }

        private enum Phase {
                case preparation
                case importation
        }

        private init() {}

        func start() {
                guard isImporting.negative && InputMemoryExportController.shared.isExporting.negative else { return }
                isImporting = true
                feedback = nil
                operation = Task {
                        defer {
                                isImporting = false
                                operation = nil
                        }
                        guard let file = await selectFile() else { return }
                        let scoped = file.startAccessingSecurityScopedResource()
                        defer { if scoped { file.stopAccessingSecurityScopedResource() } }
                        var phase = Phase.preparation
                        do {
                                try await InputMemory.waitUntilReady()
                                phase = .importation
                                let count = try await importEntries(from: file)
                                feedback = Feedback(message: LocalizedStringResource("InputMemorySettingsView.ImportInputMemory.Success \(count)", comment: "Import confirmation; the variable is the number of learned entries merged."))
                        } catch is CancellationError {
                                // Cancellation rolls back the merge and reports nothing.
                        } catch InputMemoryImportError.unsupportedFormat {
                                feedback = Feedback(message: "InputMemorySettingsView.ImportInputMemory.UnsupportedFile")
                        } catch SQLiteError.timedOut {
                                feedback = Feedback(message: "InputMemorySettingsView.ImportInputMemory.Busy")
                        } catch SQLiteError.sqlite(let code) where phase == .importation && (code == SQLITE_BUSY || code == SQLITE_LOCKED) {
                                feedback = Feedback(message: "InputMemorySettingsView.ImportInputMemory.Busy")
                        } catch {
                                switch phase {
                                case .preparation:
                                        feedback = Feedback(message: "InputMemorySettingsView.ExportInputMemory.PreparationFailed")
                                case .importation:
                                        feedback = Feedback(message: "InputMemorySettingsView.ImportInputMemory.ImportFailed")
                                }
                        }
                }
        }

        private func selectFile() async -> URL? {
                let panel = NSOpenPanel()
                panel.allowedContentTypes = [UTType(filenameExtension: "sqlite3") ?? .database]
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                panel.canChooseFiles = true

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

        private func importEntries(from file: URL) async throws -> Int64 {
                let store = InputMemory.databaseURL
                let importTask = Task.detached(priority: .utility) {
                        try InputMemoryImporter.importEntries(from: file, into: store)
                }
                return try await withTaskCancellationHandler {
                        try await importTask.value
                } onCancel: {
                        importTask.cancel()
                }
        }
}
