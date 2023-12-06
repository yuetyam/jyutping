@main
struct Preparing {
        static func main() {
                MaterialsHandler.prepare()
                SyllableDBHandler.prepare()
                IMEDBHandler.prepare()
        }
}
