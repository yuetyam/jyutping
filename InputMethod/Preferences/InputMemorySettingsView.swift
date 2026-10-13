import SwiftUI
import CoreIME
import CommonExtensions

struct InputMemorySettingsView: View {

        @State private var isInputMemoryOn: Bool = AppSettings.isInputMemoryOn
        @State private var isClearInputMemoryConfirmDialogPresented: Bool = false
        @State private var isPerformingClearInputMemory: Bool = false
        @State private var clearInputMemoryProgress: Double = 0

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading) {
                                Form {
                                        Section {
                                                Toggle("InputMemorySettingsView.InputMemory.ToggleTitle", isOn: $isInputMemoryOn)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isInputMemoryOn) { newState in
                                                                AppSettings.updateInputMemoryState(to: newState)
                                                        }
                                                HStack {
                                                        Button(role: .destructive) {
                                                                isClearInputMemoryConfirmDialogPresented = true
                                                        } label: {
                                                                Text("InputMemorySettingsView.ClearInputMemory.ButtonTitle").foregroundStyle(Color.red)
                                                        }
                                                        .confirmationDialog("InputMemorySettingsView.ClearInputMemory.ConfirmationDialog.Title", isPresented: $isClearInputMemoryConfirmDialogPresented) {
                                                                Button("InputMemorySettingsView.ClearInputMemory.ConfirmationDialog.Confirm", role: .destructive) {
                                                                        clearInputMemoryProgress = 0
                                                                        isPerformingClearInputMemory = true
                                                                        InputMemory.deleteAll()
                                                                }
                                                                Button("InputMemorySettingsView.ClearInputMemory.ConfirmationDialog.Cancel", role: .cancel) {
                                                                        isClearInputMemoryConfirmDialogPresented = false
                                                                }
                                                        }
                                                        .task(id: isPerformingClearInputMemory) {
                                                                guard isPerformingClearInputMemory else { return }
                                                                for step in 1...10 {
                                                                        do {
                                                                                try await Task.sleep(for: .milliseconds(100))
                                                                        } catch {
                                                                                return
                                                                        }
                                                                        guard Task.isCancelled.negative else { return }
                                                                        clearInputMemoryProgress = Double(step) / 10.0
                                                                }
                                                                isPerformingClearInputMemory = false
                                                        }
                                                        ProgressView(value: clearInputMemoryProgress)
                                                                .progressViewStyle(.linear)
                                                                .opacity(isPerformingClearInputMemory ? 1 : 0)
                                                }
                                        }
                                }
                                .formStyle(.grouped)
                                .scrollContentBackground(.hidden)
                                .stack(cornerRadius: 16)
                                .frame(maxWidth: 500)
                        }
                        .padding(8)
                }
                .navigationTitle("InputMemorySettingsView.NavigationTitle.TitleKey")
        }
}
