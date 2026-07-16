import Testing
@testable import CommonExtensions

@Suite("Collection extensions")
struct CollectionExtensionsTests {

        @Test("distinct preserves the first occurrence order")
        func distinct() {
                #expect([0, 1, 3, 4, 3, 2, 1, 1].distinct() == [0, 1, 3, 4, 2])
                #expect([1, 2, 3].distinct() == [1, 2, 3])
                #expect([Int]().distinct() == [])
        }

        @Test("flattenedCount totals nested collection sizes")
        func flattenedCount() {
                #expect([[1, 2, 3], [4, 5], [6, 7, 8, 9]].flattenedCount == 9)
                #expect([[1], [], [2, 3], []].flattenedCount == 3)
                #expect([[Int]]().flattenedCount == 0)
        }

        @Test("isNotEmpty is the inverse of isEmpty")
        func isNotEmpty() {
                #expect([1].isNotEmpty)
                #expect(![Int]().isNotEmpty)
                #expect("text".isNotEmpty)
                #expect(!"".isNotEmpty)
        }

        @Test("notContains negates membership")
        func notContains() {
                #expect([1, 2, 3].notContains(4))
                #expect(![1, 2, 3].notContains(2))
                #expect(["hello", "world"].notContains("test"))
        }

        @Test("clamped returns the value or the nearest bound")
        func clamped() {
                #expect(5.clamped(min: 0, max: 10) == 5)
                #expect((-5).clamped(min: 0, max: 10) == 0)
                #expect(15.clamped(min: 0, max: 10) == 10)
                #expect(2.5.clamped(min: 0, max: 5) == 2.5)
                #expect(7.5.clamped(min: 0, max: 5) == 5)
        }
}
