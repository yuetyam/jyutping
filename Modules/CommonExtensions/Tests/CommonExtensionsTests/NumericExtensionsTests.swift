import Testing
@testable import CommonExtensions

@Suite("Numeric extensions")
struct NumericExtensionsTests {

        @Test("summation returns the additive identity for empty sequences")
        func summation() {
                #expect([1, 2, 3, 4, 5].summation == 15)
                #expect([1.5, 2.5, 3.0].summation == 7.0)
                #expect([Int]().summation == 0)
        }

        @Test("toInt64 converts signed and unsigned binary integers")
        func toInt64() {
                #expect(Int(-42).toInt64() == -42)
                #expect(UInt(42).toInt64() == 42)
        }

        @Test("radix100Overflowed uses base-100 wrapping arithmetic")
        func radix100Overflowed() {
                #expect([20, 21, 22].radix100Overflowed() == 202122)
                #expect([Int]().radix100Overflowed() == 0)

                let values = Array(repeating: 99, count: 10)
                #expect(values.radix100Overflowed() == values.reduce(0, { $0 &* 100 &+ $1 }))
        }

        @Test("decimalOverflowed uses base-10 wrapping arithmetic")
        func decimalOverflowed() {
                #expect([2, 3, 4].decimalOverflowed() == 234)
                #expect([Int]().decimalOverflowed() == 0)

                let values = Array(repeating: 9, count: 20)
                #expect(values.decimalOverflowed() == values.reduce(0, { $0 &* 10 &+ $1 }))
        }
}
