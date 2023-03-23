import Foundation
import SQLite3

@main
struct Preparing {
        static func main() {
                MaterialsHandler.prepare()
                SyllableDBHandler.prepare()
                IMEDBHandler.prepare()
        }
}
