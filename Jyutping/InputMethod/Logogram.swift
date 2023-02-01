import Foundation
import CoreIME

extension Logogram {
        private(set) static var current: Logogram = {
                let preference: Int = UserDefaults.standard.integer(forKey: "logogram")
                switch preference {
                case 1: return .traditional
                case 2: return .hongkong
                case 3: return .taiwan
                case 4: return .simplified
                default: return .traditional
                }
        }()
        static func updateCurrent(to newOption: Logogram) {
                current = newOption
                let value: Int = newOption.rawValue
                UserDefaults.standard.set(value, forKey: "logogram")
        }
}

