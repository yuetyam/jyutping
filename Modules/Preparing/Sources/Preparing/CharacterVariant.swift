import Foundation
import CommonExtensions

struct CharacterVariant {
        struct VariantMap: Hashable {
                let left: UInt32
                let right: UInt32
        }
        static func process(_ sourceUrl: URL) -> [VariantMap] {
                guard let sourceContent: String = try? String(contentsOf: sourceUrl, encoding: .utf8) else { fatalError("Can not read file from URL: \(sourceUrl)") }
                let sourceLines: [String] = sourceContent
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .filter({ !$0.isEmpty })
                        .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                        .filter({ !($0.isEmpty || $0.hasPrefix("#")) })
                        .distinct()
                let variantMaps = sourceLines.flatMap { line -> [VariantMap] in
                        let errorMessage: String = "Bad format in line text: \(line)"
                        // let warningMessage: String = "Not Ideographic: \(line)"
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                        guard parts.count >= 2 else { fatalError(errorMessage) }
                        let leftText = parts[0]
                        let rightText = parts[1]
                        guard leftText.count == 1 else { fatalError(errorMessage) }
                        switch rightText.count {
                        case 0:
                                fatalError(errorMessage)
                        case 1:
                                guard let leftChar = leftText.first, let rightChar = rightText.first else { fatalError(errorMessage) }
                                guard let leftCode = leftChar.unicodeScalars.first?.value else { fatalError(errorMessage) }
                                guard let rightCode = rightChar.unicodeScalars.first?.value else { fatalError(errorMessage) }
                                guard leftCode.isIdeographicCodePoint else {
                                        // print(warningMessage)
                                        return []
                                }
                                guard rightCode.isIdeographicCodePoint else {
                                        // print(warningMessage)
                                        return []
                                }
                                guard rightCode != leftCode else { fatalError(errorMessage) }
                                return [VariantMap(left: leftCode, right: rightCode)]
                        default:
                                guard let leftChar = leftText.first else { fatalError(errorMessage) }
                                guard let leftCode = leftChar.unicodeScalars.first?.value else { fatalError(errorMessage) }
                                guard leftCode.isIdeographicCodePoint else {
                                        // print(warningMessage)
                                        return []
                                }
                                let rightComponents = rightText.split(separator: String.space).map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                let maps = rightComponents.compactMap({ text -> VariantMap? in
                                        guard let rightCode = text.first?.unicodeScalars.first?.value else { fatalError(errorMessage) }
                                        guard rightCode.isIdeographicCodePoint else {
                                                // print(warningMessage)
                                                return nil
                                        }
                                        // guard rightCode != leftCode else { fatalError(errorMessage) }
                                        return VariantMap(left: leftCode, right: rightCode)
                                })
                                return maps
                        }
                }
                return variantMaps.distinct().sorted(by: { $0.left < $1.left })
        }
}
