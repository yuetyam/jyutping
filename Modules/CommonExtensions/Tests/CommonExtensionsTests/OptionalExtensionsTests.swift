import Testing
import CommonExtensions

@Suite("Optional extensions")
struct OptionalExtensionsTests {

        @Test("isNil checks whether a value is absent")
        func isNil() {
                let absent: Int? = nil
                let present: Int? = 0
                #expect(absent.isNil)
                #expect(!present.isNil)
        }

        @Test("isNotNil checks whether a value is present")
        func isNotNil() {
                let absent: Int? = nil
                let present: Int? = 0
                #expect(!absent.isNotNil)
                #expect(present.isNotNil)
        }

        @Test("nil checks support non-Equatable wrapped types")
        func nonEquatable() {
                let absent: (() -> Void)? = nil
                let present: (() -> Void)? = {}
                #expect(absent.isNil)
                #expect(!present.isNil)
                #expect(!absent.isNotNil)
                #expect(present.isNotNil)
        }

        @Test("nil checks inspect only the outer optional")
        func nestedOptionals() {
                let absent: Int?? = nil
                let presentNil: Int?? = .some(nil)
                let presentValue: Int?? = .some(.some(1))
                #expect(absent.isNil)
                #expect(!presentNil.isNil)
                #expect(!presentValue.isNil)
                #expect(!absent.isNotNil)
                #expect(presentNil.isNotNil)
                #expect(presentValue.isNotNil)
        }
}
