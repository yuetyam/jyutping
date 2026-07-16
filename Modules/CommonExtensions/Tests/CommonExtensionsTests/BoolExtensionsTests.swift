import Testing
@testable import CommonExtensions

@Suite("Bool extensions")
struct BoolExtensionsTests {

        @Test("negative negates the Boolean value")
        func negative() {
                #expect(true.negative == false)
                #expect(false.negative == true)
        }

        @Test("then runs its action only for true")
        func then() {
                var trueCount = 0
                true.then { trueCount += 1 }
                #expect(trueCount == 1)

                var falseCount = 0
                false.then { falseCount += 1 }
                #expect(falseCount == 0)
        }
}
