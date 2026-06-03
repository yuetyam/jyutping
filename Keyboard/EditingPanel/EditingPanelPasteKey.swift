import SwiftUI
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct EditingPanelGlassSystemPasteKey: View {
        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @State private var isPasting: Bool = false
        @State private var taskInstance: Task<Void, Never>? = nil
        var body: some View {
                ZStack {
                        Color.clear
                                .glassEffect(isPasting ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius, style: .continuous))
                                .shadow(color: isPasting ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(isPasting ? 2 : 4)
                        PasteButton(payloadType: String.self) { strings in
                                isPasting = true
                                taskInstance?.cancel()
                                taskInstance = Task {
                                        try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                        if Task.isCancelled.negative {
                                                await MainActor.run {
                                                        withAnimation {
                                                                isPasting = false
                                                        }
                                                }
                                        }
                                }
                                AudioFeedback.inputed()
                                context.triggerHapticFeedback()
                                if let text = strings.first, text.isNotEmpty {
                                        context.operate(.input(text))
                                }
                        }
                        .buttonBorderShape(.capsule)
                        .labelStyle(.titleAndIcon)
                }
                .onDisappear {
                        taskInstance?.cancel()
                }
        }
}

struct EditingPanelPasteKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(isTouching ? 2 : 4)
                        VStack(spacing: 4) {
                                Image(systemName: "doc.on.clipboard")
                                Text("EditingPanel.Paste")
                                        .font(.labelCaption)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .padding(.horizontal, 4)
                        }
                        .opacity(context.isClipboardEmpty ? 0.5 : 1)
                }
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                }
                        }
                        .onEnded { _ in
                                context.operate(.paste)
                        }
                )
        }
}
