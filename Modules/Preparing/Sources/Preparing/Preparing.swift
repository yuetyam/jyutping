@main
struct Preparing {
        static func main() async {
                await withTaskGroup(of: Void.self) { group in
                        group.addTask { await AppDataPreparer.prepare() }
                        group.addTask { await DatabasePreparer.prepare() }
                        await group.waitForAll()
                }
        }
}
