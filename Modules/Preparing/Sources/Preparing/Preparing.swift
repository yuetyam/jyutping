@main
struct Preparing {
        static func main() {
                AppDataPreparer.prepare()
                SyllablePreparer.prepare()
                DatabasePreparer.prepare()
        }
}
