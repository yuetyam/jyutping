import Foundation

extension DateFormatter {
        static let normalized: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                return formatter
        }()
        static let minimalist: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd-HHmmss"
                return formatter
        }()
        static let humanFriendly: DateFormatter = {
                let formatter = DateFormatter()
                formatter.locale = .autoupdatingCurrent
                formatter.dateStyle = .long
                formatter.timeStyle = .medium
                return formatter
        }()
}
