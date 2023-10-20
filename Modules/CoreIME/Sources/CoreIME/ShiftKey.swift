//
//  ShiftKey.swift
//
//
//  Created by zengwx on 2023/10/20.
//

import Foundation
import AppKit
import Carbon

public struct ShiftKey {
    private static var shiftKeyFlag = NSEvent.ModifierFlags.shift
    private static var shiftKeyCode = [kVK_Shift, kVK_RightShift]
    private static var shiftKeyEventFeature = 0

    public static func isShiftKeyTaped(event: NSEvent) -> Bool {
        guard event.type == .flagsChanged && shiftKeyCode.contains(Int(event.keyCode))
        else { shiftKeyEventFeature = 0; return false }

        if event.modifierFlags == shiftKeyFlag || event.modifierFlags == .init(rawValue: 0) && shiftKeyEventFeature > 1 {
            shiftKeyEventFeature += 1
        }

        guard shiftKeyEventFeature == 4 else { return false}
        shiftKeyEventFeature = 0
        return true
    }
}
