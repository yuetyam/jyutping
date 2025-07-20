import SwiftUI
import CommonExtensions
import CoreIME

struct TenKeySpecialKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        #if DEBUG
                        ZStack(alignment: .bottom) {
                                Color.clear
                                Text(verbatim: context.inputStage.isBuffering ? PresetConstant.separate : PresetConstant.reverseLookup)
                                        .font(.keyFootnote)
                                        .opacity(0.35)
                        }
                        .padding(.bottom, 5)
                        Text(verbatim: context.inputStage.isBuffering ? String.separator : "R")
                        #endif
                }
                .frame(width: context.tenKeyWidthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                if context.inputStage.isBuffering {
                                        context.handle(.apostrophe)
                                }
                         }
                )
                .disabled(true)
        }
}
