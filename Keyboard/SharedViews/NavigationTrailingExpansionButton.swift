import SwiftUI
import CommonExtensions

/// Toggle keyboard height
struct NavigationTrailingExpansionButton: View {
        @EnvironmentObject private var context: KeyboardViewController
        private let expandImageName: String = {
                if #available(iOSApplicationExtension 17.0, *) {
                        return "arrow.down.backward.and.arrow.up.forward"
                } else {
                        return "arrow.up.and.line.horizontal.and.arrow.down"
                }
        }()
        private let collapseImageName: String = {
                if #available(iOSApplicationExtension 17.0, *) {
                        return "arrow.up.forward.and.arrow.down.backward"
                } else {
                        return "arrow.down.and.line.horizontal.and.arrow.up"
                }
        }()
        var body: some View {
                HStack(spacing: 0) {
                        TransparentButton(width: 12, height: PresetConstant.buttonLength, action: action)
                        if #available(iOSApplicationExtension 26.0, *) {
                                Button(action: action) {
                                        ZStack {
                                                Color.interactiveClear
                                                Image(systemName: context.isKeyboardHeightExpanded ? collapseImageName : expandImageName)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(13)
                                        }
                                        .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                                }
                                .buttonStyle(.plain)
                                .glassEffect(.clear, in: .circle)
                        } else {
                                Button(action: action) {
                                        ZStack {
                                                Color.interactiveClear
                                                Image(systemName: context.isKeyboardHeightExpanded ? collapseImageName : expandImageName)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(13)
                                        }
                                        .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                                }
                                .buttonStyle(.plain)
                        }
                        TransparentButton(width: 4, height: PresetConstant.buttonLength, action: action)
                }
        }
        private func action() {
                AudioFeedback.modified()
                context.triggerHapticFeedback()
                context.toggleKeyboardHeight()
        }
}
