import Foundation
import SQLite3

@main
struct Prepare {
        static func main() {
                MaterialsHandler.prepare()
                IMEDBHandler.prepare()
        }
}
