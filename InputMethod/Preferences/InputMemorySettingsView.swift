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
                                                        Button {
                                                                // TODO: Implement exportation
                                                        } label: {
                                                                Label("InputMemorySettingsView.ExportInputMemory.ButtonTitle", systemImage: "square.and.arrow.up")
                                                        }
                                                        Button {
                                                                // TODO: Implement importation
                                                        } label: {
                                                                Label("InputMemorySettingsView.ImportInputMemory.ButtonTitle", systemImage: "square.and.arrow.down")
                                                        }
                                                }
                                                HStack {
                                                        Button(role: .destructive) {
                                                                isClearInputMemoryConfirmDialogPresented = true
                                                        } label: {
                                                                Label("InputMemorySettingsView.ClearInputMemory.ButtonTitle", systemImage: "trash")
                                                                        .labelStyle(.colorTint(titleColor: .red, iconColor: .red))
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

private extension LabelStyle where Self == ColorLabelStyle {

        static func colorTint(titleColor: Color = Color.primary, iconColor: Color = Color.accentColor) -> Self {
                return ColorLabelStyle(titleColor: titleColor, iconColor: iconColor)
        }
}

private struct ColorLabelStyle: LabelStyle {

        init(titleColor: Color, iconColor: Color) {
                self.titleColor = titleColor
                self.iconColor = iconColor
        }

        private let titleColor: Color

        private let iconColor: Color

        func makeBody(configuration: Configuration) -> some View {
                Label(
                        title: { configuration.title.foregroundStyle(titleColor) },
                        icon: { configuration.icon.foregroundStyle(iconColor) }
                )
        }
}
