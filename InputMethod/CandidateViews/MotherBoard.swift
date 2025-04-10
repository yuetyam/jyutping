import SwiftUI
import CommonExtensions

struct MotherBoard: View {

        @EnvironmentObject private var context: AppContext

        var body: some View {
                ZStack(alignment: context.quadrant.alignment) {
                        Color.clear
                        if context.inputForm.isOptions {
                                OptionsView()
                        } else if context.isClean {
                                Color.clear
                        } else {
                                CandidateBoard()
                                        .background(
                                                // TODO: Replace this with onGeometryChange modifier when dropping macOS 12 support
                                                GeometryReader { proxy in
                                                        Color.clear.task(id: proxy.size) {
                                                                guard context.quadrant.isNegativeHorizontal else { return }
                                                                NotificationCenter.default.post(name: .contentSize, object: nil, userInfo: [NotificationKey.contentSize : proxy.size])
                                                        }
                                                }
                                        )
                        }
                }
        }
}
