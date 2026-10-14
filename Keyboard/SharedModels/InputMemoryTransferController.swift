import SwiftUI
import Combine
import UniformTypeIdentifiers
import SQLite3
import CommonExtensions
import SQLiteWrapper

/// Retained independently of the SettingsView, so leaving the settings does not interrupt a transfer.
@MainActor
final class InputMemoryTransferController: ObservableObject {

        static let shared = InputMemoryTransferController()
        @Published private(set) var isExporting: Bool = false
        @Published private(set) var isImporting: Bool = false

        /// The prepared export file, waiting for the file mover. Non-nil while the file mover is presented.
        @Published private(set) var exportedFile: URL?
        @Published var isImporterPresented: Bool = false
        @Published var feedback: LocalizedStringKey?

        private var exportedCount: Int64 = 0
        private var exportWorkspace: URL?

        var isTransferring: Bool { isExporting || isImporting }

        static let contentType: UTType = UTType(filenameExtension: "sqlite3") ?? .database

        private init() {}


        // MARK: - Export

        func startExport() {
                guard isTransferring.negative && isImporterPresented.negative else { return }
                feedback = nil
                guard InputMemory.isReady else {
                        feedback = "SettingsView.ExportInputMemory.SourceBusy"
                        return
                }
                isExporting = true
                removeExportWorkspace()
                Task {
                        do {
                                let workspace = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
                                try FileManager.default.createDirectory(at: workspace, withIntermediateDirectories: false)
                                exportWorkspace = workspace
                                let output = workspace.appendingPathComponent("memory-\(Self.dateText()).sqlite3")
                                let source = InputMemory.databaseURL
                                let exportTask = Task.detached(priority: .utility) {
                                        try InputMemoryExporter.export(source: source, output: output)
                                }
                                exportedCount = try await exportTask.value
                                exportedFile = output
                        } catch SQLiteError.timedOut {
                                feedback = "SettingsView.ExportInputMemory.SourceBusy"
                                finishExport()
                        } catch SQLiteError.invalidFormat {
                                feedback = "SettingsView.ExportInputMemory.ValidationFailed"
                                finishExport()
                        } catch {
                                feedback = "SettingsView.ExportInputMemory.ExportFailed"
                                finishExport()
                        }
                }
        }

        /// The file mover was dismissed. The workspace is kept, because the move can still be in progress.
        func dismissExport() {
                exportedFile = nil
                isExporting = false
        }

        func completeExport(_ result: Result<URL, Error>) {
                switch result {
                case .success:
                        let count = exportedCount
                        feedback = "SettingsView.ExportInputMemory.Success \(count)"
                case .failure(let error):
                        // Cancellation reports nothing.
                        if (error as? CocoaError)?.code != .userCancelled {
                                feedback = "SettingsView.ExportInputMemory.WriteFailed"
                        }
                }
                finishExport()
        }

        private func finishExport() {
                exportedFile = nil
                removeExportWorkspace()
                isExporting = false
        }

        private func removeExportWorkspace() {
                guard let exportWorkspace else { return }
                try? FileManager.default.removeItem(at: exportWorkspace)
                self.exportWorkspace = nil
        }

        private static func dateText() -> String {
                let formatter = DateFormatter()
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = .current
                formatter.dateFormat = "yyyyMMdd-HHmmss"
                return formatter.string(from: .now)
        }


        // MARK: - Import

        func presentImporter() {
                guard isTransferring.negative && exportedFile == nil else { return }
                feedback = nil
                isImporterPresented = true
        }

        func completeImport(_ result: Result<URL, Error>) {
                let file: URL
                switch result {
                case .success(let url):
                        file = url
                case .failure(let error):
                        // Cancellation reports nothing.
                        if (error as? CocoaError)?.code != .userCancelled {
                                feedback = "SettingsView.ImportInputMemory.ImportFailed"
                        }
                        return
                }
                guard isTransferring.negative else { return }
                guard InputMemory.isReady else {
                        feedback = "SettingsView.ImportInputMemory.Busy"
                        return
                }
                isImporting = true
                Task {
                        defer { isImporting = false }
                        let scoped = file.startAccessingSecurityScopedResource()
                        defer { if scoped { file.stopAccessingSecurityScopedResource() } }
                        let store = InputMemory.databaseURL
                        do {
                                let importTask = Task.detached(priority: .utility) {
                                        try InputMemoryImporter.importEntries(from: file, into: store)
                                }
                                let count = try await importTask.value
                                feedback = "SettingsView.ImportInputMemory.Success \(count)"
                        } catch InputMemoryImportError.unsupportedFormat {
                                feedback = "SettingsView.ImportInputMemory.UnsupportedFile"
                        } catch SQLiteError.timedOut {
                                feedback = "SettingsView.ImportInputMemory.Busy"
                        } catch SQLiteError.sqlite(let code) where code == SQLITE_BUSY || code == SQLITE_LOCKED {
                                feedback = "SettingsView.ImportInputMemory.Busy"
                        } catch {
                                feedback = "SettingsView.ImportInputMemory.ImportFailed"
                        }
                }
        }
}
