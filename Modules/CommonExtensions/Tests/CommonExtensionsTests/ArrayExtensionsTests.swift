import Testing
@testable import CommonExtensions

@Suite("Array extensions")
struct ArrayExtensionsTests {

        @Test("fetch returns the requested element when the index is valid")
        func fetchValidIndex() {
                let values = [10, 20, 30]

                #expect(values.fetch(0) == 10)
                #expect(values.fetch(2) == 30)
        }

        @Test("fetch returns nil when the index is outside the array")
        func fetchInvalidIndex() {
                let values = [10, 20, 30]

                #expect(values.fetch(-1) == nil)
                #expect(values.fetch(3) == nil)
                #expect([Int]().fetch(0) == nil)
        }

        @Test("chunked splits arrays into fixed-size chunks")
        func chunked() {
                #expect([1, 2, 3, 4, 5, 6].chunked(size: 3) == [[1, 2, 3], [4, 5, 6]])
                #expect([1, 2, 3, 4, 5, 6, 7].chunked(size: 3) == [[1, 2, 3], [4, 5, 6], [7]])
                #expect([1, 2, 3].chunked(size: 10) == [[1, 2, 3]])
                #expect([Int]().chunked(size: 3) == [])
        }
}
