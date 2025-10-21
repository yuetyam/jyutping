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
                                        .onGeometryChange(for: CGSize.self) { proxy in
                                                proxy.size
                                        } action: { newSize in
                                                guard context.quadrant.isNegativeHorizontal else { return }
                                                NotificationCenter.default.post(name: .contentSize, object: nil, userInfo: [NotificationKey.contentSize : newSize])
                                        }
                        }
                }
        }
}
