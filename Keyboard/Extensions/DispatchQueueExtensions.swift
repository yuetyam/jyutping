import Foundation

extension DispatchQueue {
        static let preferences: DispatchQueue = DispatchQueue(label: "im.cantonese.CantoneseIM.Keyboard.preferences", qos: .userInitiated)
}
