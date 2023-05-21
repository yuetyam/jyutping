import SwiftUI

struct KeyElementView: View {

        let element: KeyElement

        var body: some View {
                VStack {
                        HStack {
                                if let leading = element.topLeading {
                                        Text(verbatim: leading)
                                }
                                Spacer()
                                if let center = element.topCenter {
                                        Text(verbatim: center)
                                }
                                Spacer()
                                if let trailing = element.topTrailing {
                                        Text(verbatim: trailing)
                                }
                        }
                        Spacer()
                        HStack {
                                if let leading = element.centerLeading {
                                        Text(verbatim: leading)
                                }
                                Spacer()
                                Text(verbatim: element.center).font(.title3)
                                Spacer()
                                if let trailing = element.centerTrailing {
                                        Text(verbatim: trailing)
                                }
                        }
                        Spacer()
                        HStack {
                                if let leading = element.bottomLeading {
                                        Text(verbatim: leading)
                                }
                                Spacer()
                                if let center = element.bottomCenter {
                                        Text(verbatim: center)
                                }
                                Spacer()
                                if let trailing = element.bottomTrailing {
                                        Text(verbatim: trailing)
                                }
                        }
                }
        }
}

struct KeyElement: Hashable {

        init(_ center: String, centerLeading: String? = nil, centerTrailing: String? = nil, topCenter: String? = nil, topLeading: String? = nil, topTrailing: String? = nil, bottomCenter: String? = nil, bottomLeading: String? = nil, bottomTrailing: String? = nil) {
                self.center = center
                self.centerLeading = centerLeading
                self.centerTrailing = centerTrailing
                self.topCenter = topCenter
                self.topLeading = topLeading
                self.topTrailing = topTrailing
                self.bottomCenter = bottomCenter
                self.bottomLeading = bottomLeading
                self.bottomTrailing = bottomTrailing
        }

        let center: String
        let centerLeading: String?
        let centerTrailing: String?

        let topCenter: String?
        let topLeading: String?
        let topTrailing: String?

        let bottomCenter: String?
        let bottomLeading: String?
        let bottomTrailing: String?
}

struct KeyUnit: Hashable {

        init(primary: KeyElement, assistants: [KeyElement] = [], widthUnitTimes: CGFloat = 1) {
                self.primary = primary
                self.assistants = assistants
                self.widthUnitTimes = widthUnitTimes
        }

        let primary: KeyElement
        let assistants: [KeyElement]
        let widthUnitTimes: CGFloat
}
