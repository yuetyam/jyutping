import SwiftUI
import Combine
import UniformTypeIdentifiers
import SQLite3
import CommonExtensions
import SQLiteWrapper

/// Retained independently of the SettingsView, so leaving the settings does not interrupt an import.
/// An export is cancelled when the SettingsView disappears or the keyboard is dismissed.
@MainActor
final class InputMemoryTransferController: ObservableObject {

        static let shared = InputMemoryTransferController()
        @Published private(set) var isExporting: Bool = false
        @Published private(set) var isImporting: Bool = false

        /// Both directions use the document picker in open mode.
        /// The export mode picker has a filename field, which can not lay out within the keyboard's own window.
        enum PickerPurpose {
                case exportDestination
                case importSource
        }

        /// One file importer serves both purposes, because multiple file importers in one view hierarchy can conflict.
        @Published var isPickerPresented: Bool = false
        /// Kept after dismissal, because the presentation binding can reset before the completion arrives.
        @Published private(set) var pickerPurpose: PickerPurpose = .importSource
        var pickerContentTypes: [UTType] {
                switch pickerPurpose {
                case .exportDestination:
                        return [.folder]
                case .importSource:
                        return [Self.contentType]
                }
        }
        @Published var feedback: LocalizedStringKey?

        private var exportTask: Task<Void, Never>?

        var isTransferring: Bool { isExporting || isImporting }

        static let contentType: UTType = UTType(filenameExtension: "sqlite3") ?? .database

        private init() {}

        func completePicker(_ result: Result<URL, Error>) {
                switch pickerPurpose {
                case .exportDestination:
                        completeExportDestination(result)
                case .importSource:
                        completeImport(result)
                }
        }


        // MARK: - Export

        func presentExportDestinationPicker() {
                guard isTransferring.negative && isPickerPresented.negative else { return }
                feedback = nil
                pickerPurpose = .exportDestination
                isPickerPresented = true
        }

        private func completeExportDestination(_ result: Result<URL, Error>) {
                let folder: URL
                switch result {
                case .success(let url):
                        folder = url
                case .failure(let error):
                        // Cancellation reports nothing.
                        if (error as? CocoaError)?.code != .userCancelled {
                                feedback = "SettingsView.ExportInputMemory.WriteFailed"
                        }
                        return
                }
                guard isTransferring.negative else { return }
                guard InputMemory.isReady else {
                        feedback = "SettingsView.ExportInputMemory.SourceBusy"
                        return
                }
                isExporting = true
                let filename = "memory-\(Self.dateText())"
                exportTask = Task {
                        let workspace = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
                        defer { try? FileManager.default.removeItem(at: workspace) }
                        do {
                                try FileManager.default.createDirectory(at: workspace, withIntermediateDirectories: false)
                                let output = workspace.appendingPathComponent("export.sqlite3")
                                let source = InputMemory.databaseURL
                                let export = Task.detached(priority: .utility) {
                                        let count = try InputMemoryExporter.export(source: source, output: output)
                                        try Task.checkCancellation()
                                        do {
                                                try Self.publish(output: output, folder: folder, filename: filename)
                                        } catch {
                                                throw ExportWriteError(underlying: error)
                                        }
                                        return count
                                }
                                let count = try await withTaskCancellationHandler {
                                        try await export.value
                                } onCancel: {
                                        export.cancel()
                                }
                                // cancelExport() has already reset the state.
                                guard Task.isCancelled.negative else { return }
                                feedback = "SettingsView.ExportInputMemory.Success \(count)"
                        } catch {
                                // cancelExport() has already reset the state.
                                guard Task.isCancelled.negative else { return }
                                if error is ExportWriteError {
                                        feedback = "SettingsView.ExportInputMemory.WriteFailed"
                                } else {
                                        switch error as? SQLiteError {
                                        case .timedOut:
                                                feedback = "SettingsView.ExportInputMemory.SourceBusy"
                                        case .invalidFormat:
                                                feedback = "SettingsView.ExportInputMemory.ValidationFailed"
                                        default:
                                                feedback = "SettingsView.ExportInputMemory.ExportFailed"
                                        }
                                }
                        }
                        exportTask = nil
                        isExporting = false
                }
        }

        /// Called when the SettingsView disappears or the keyboard is dismissed. Reports nothing.
        func cancelExport() {
                if isPickerPresented && pickerPurpose == .exportDestination {
                        isPickerPresented = false
                }
                guard isExporting else { return }
                exportTask?.cancel()
                exportTask = nil
                isExporting = false
        }

        private struct ExportWriteError: Error {
                let underlying: Error
        }

        /// Copies the validated output into the selected folder under a new, unused name.
        nonisolated private static func publish(output: URL, folder: URL, filename: String) throws {
                let isScoped = folder.startAccessingSecurityScopedResource()
                defer { if isScoped { folder.stopAccessingSecurityScopedResource() } }
                var coordinationError: NSError?
                var copyError: Error?
                NSFileCoordinator().coordinate(writingItemAt: folder, options: [], error: &coordinationError) { directory in
                        do {
                                try copy(output: output, directory: directory, filename: filename)
                        } catch {
                                copyError = error
                        }
                }
                if let error = coordinationError ?? copyError { throw error }
        }

        /// Never replaces an existing file. Example names: memory-20261016-054500.sqlite3, memory-20261016-054500-2.sqlite3
        nonisolated private static func copy(output: URL, directory: URL, filename: String) throws {
                for index in 1...99 {
                        let name = (index == 1) ? filename : "\(filename)-\(index)"
                        let destination = directory.appendingPathComponent(name).appendingPathExtension("sqlite3")
                        do {
                                try FileManager.default.copyItem(at: output, to: destination)
                                return
                        } catch CocoaError.fileWriteFileExists {
                                continue
                        } catch {
                                try? FileManager.default.removeItem(at: destination)
                                throw error
                        }
                }
                throw CocoaError(.fileWriteFileExists)
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
                guard isTransferring.negative && isPickerPresented.negative else { return }
                feedback = nil
                pickerPurpose = .importSource
                isPickerPresented = true
        }

        private func completeImport(_ result: Result<URL, Error>) {
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
