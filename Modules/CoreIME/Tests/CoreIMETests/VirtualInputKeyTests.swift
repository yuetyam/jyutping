import Testing
@testable import CoreIME
import CommonExtensions

@Suite("Virtual input keys")
struct VirtualInputKeyTests {

        @Test("identity and ordering use stable key codes")
        func identityAndOrdering() {
                #expect(VirtualInputKey.letterA.id == VirtualInputKey.letterA.code)
                #expect(VirtualInputKey.letterA.character == "a")
                #expect(VirtualInputKey.letterA.text == "a")
                #expect(VirtualInputKey.number9 < VirtualInputKey.letterA)
                #expect(Set([VirtualInputKey.letterA, .letterA]).count == 1)
        }

        @Test("classification predicates distinguish numbers letters and controls")
        func classification() {
                #expect(VirtualInputKey.number0.isNumber)
                #expect(VirtualInputKey.number0.isToneNumber == false)
                #expect(VirtualInputKey.number6.isToneNumber)
                #expect(VirtualInputKey.number7.isToneNumber == false)
                #expect(VirtualInputKey.letterA.isLetter)
                #expect(VirtualInputKey.letterA.isSyllableLetter)
                #expect(VirtualInputKey.letterV.isToneLetter)
                #expect(VirtualInputKey.letterV.isSyllableLetter == false)
                #expect(VirtualInputKey.letterQ.isToneInputKey)
                #expect(VirtualInputKey.number3.isToneInputKey)
                #expect(VirtualInputKey.number9.isToneInputKey == false)
                #expect(VirtualInputKey.letterR.isReverseLookupTrigger)
                #expect(VirtualInputKey.letterA.isReverseLookupTrigger == false)
                #expect(VirtualInputKey.letterY.isYLetterY)
                #expect(VirtualInputKey.letterM.isMLetterM)
                #expect(VirtualInputKey.apostrophe.isApostrophe)
                #expect(VirtualInputKey.grave.isGrave)
        }

        @Test("digits return numeric values only for number keys")
        func digits() {
                #expect(VirtualInputKey.number0.digit == 0)
                #expect(VirtualInputKey.number9.digit == 9)
                #expect(VirtualInputKey.letterA.digit.isNil)
        }

        @Test("matching accepts hardware codes internal codes and characters")
        func matching() {
                #expect(VirtualInputKey.isMatchedNumber(keyCode: VirtualInputKey.number5.keyCode))
                #expect(VirtualInputKey.isMatchedNumber(keyCode: VirtualInputKey.letterA.keyCode) == false)
                #expect(VirtualInputKey.isMatchedLetter(keyCode: VirtualInputKey.letterZ.keyCode))
                #expect(VirtualInputKey.isMatchedLetter(keyCode: VirtualInputKey.number0.keyCode) == false)
                #expect(VirtualInputKey.matchInputKey(for: VirtualInputKey.apostrophe.keyCode) == .apostrophe)
                #expect(VirtualInputKey.matchInputKey(for: VirtualInputKey.grave.keyCode) == .grave)
                #expect(VirtualInputKey.matchInputKey(for: VirtualInputKey.letterG.keyCode) == .letterG)
                #expect(VirtualInputKey.matchInputKey(for: VirtualInputKey.number8.keyCode) == .number8)
                #expect(VirtualInputKey.matchInputKey(for: UInt16.max).isNil)
                #expect(VirtualInputKey.matchInputKey(for: VirtualInputKey.letterG.code) == .letterG)
                #expect(VirtualInputKey.matchInputKey(for: -1).isNil)
                #expect(VirtualInputKey.matchInputKey(for: Character("g")) == .letterG)
                #expect(VirtualInputKey.matchInputKey(for: Character("G")).isNil)
        }

        @Test("key collections expose stable encodings and anchor normalization")
        func collectionEncodings() {
                #expect([VirtualInputKey.letterG, .letterW] == VirtualInputKey.GWInputKeys)
                #expect([VirtualInputKey.letterK, .letterW] == VirtualInputKey.KWInputKeys)
                #expect(inputKeys("ngo").conjoinedCode == 3_326_34)
                #expect(inputKeys("yay").anchorNormalized == inputKeys("jaj"))
                #expect(3_326_34.matchedInputKeys == inputKeys("ngo"))
                #expect(0.matchedInputKeys.isEmpty)
        }
}
