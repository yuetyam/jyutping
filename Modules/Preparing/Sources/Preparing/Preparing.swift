import Foundation
import SQLite3

@main
struct Preparing {
        static func main() {
                copyFiles()
                MaterialsHandler.prepare()
                SyllableDBHandler.prepare()
                IMEDBHandler.prepare()
        }

        private static func copyFiles() {
                let manager = FileManager.default
                guard let hansMessSourcePath: String = Bundle.module.path(forResource: "HansMess", ofType: "txt") else { fatalError("Can not find HansMess.txt") }
                guard manager.fileExists(atPath: hansMessSourcePath) else { fatalError("HansMess.txt does not exist.") }
                let hansMessDestinationPath: String = "../Materials/Sources/Materials/Resources/HansMess.txt"
                if manager.fileExists(atPath: hansMessDestinationPath) {
                        try? manager.removeItem(atPath: hansMessDestinationPath)
                }
                do {
                        try manager.copyItem(atPath: hansMessSourcePath, toPath: hansMessDestinationPath)
                } catch {
                        print(error.localizedDescription)
                }
        }
}
