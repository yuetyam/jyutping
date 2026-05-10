import SwiftUI
import CommonExtensions
import AppDataSource

extension Metro.Line {
        var backgroundColor: Color {
                switch group {
                case "CantonMetro":
                        /// Source: https://zh.wikipedia.org/zh-hk/Template:廣州地鐵顏色/doc
                        switch name {
                        case "1 號線": Color(rgb: 0xF3D03E)
                        case "2 號線": Color(rgb: 0x00629B)
                        case "3 號線・主線",
                             "3 號線・支線": Color(rgb: 0xE89E47)
                        case "4 號線": Color(rgb: 0x01824A)
                        case "5 號線": Color(rgb: 0xC70541)
                        case "6 號線": Color(rgb: 0x640346)
                        case "7 號線": Color(rgb: 0x9DD32D)
                        case "8 號線": Color(rgb: 0x00858A)
                        case "9 號線": Color(rgb: 0x5EC998)
                        case "10 號線": Color(rgb: 0x6E90B6)
                        case "11 號線": Color(rgb: 0xF5BB17)
                        case "12 號線": Color(rgb: 0x59621D)
                        case "13 號線": Color(rgb: 0x888600)
                        case "14 號線・主線",
                             "14 號線・支線": Color(rgb: 0x792720)
                        case "18 號線": Color(rgb: 0x364C9C)
                        case "21 號線": Color(rgb: 0x230B55)
                        case "22 號線": Color(rgb: 0xD14D23)
                        case "廣佛線": Color(rgb: 0xBBD80A)
                        case "APM 線": Color(rgb: 0x00BDE2)
                        case "海珠有軌 1 號線": Color(rgb: 0x5EB630)
                        case "黃埔有軌 1 號線": Color(rgb: 0xBD0000)
                        case "黃埔有軌 2 號線": Color(rgb: 0xE4007F)
                        default: Color.black
                        }
                case "FatshanMetro":
                        switch name {
                        case "廣佛線": Color(rgb: 0xBBD80A)
                        case "2 號線": Color(rgb: 0xEB0000)
                        case "3 號線": Color(rgb: 0x004DB3)
                        case "南海有軌 1 號線": Color(rgb: 0x61B3E3)
                        default: Color.black
                        }
                case "MacauMetro":
                        switch name {
                        case "氹仔線": Color(rgb: 0x96C93C)
                        case "石排灣線": Color(rgb: 0x8966C3)
                        case "橫琴線": Color(rgb: 0xB82A3C)
                        default: Color.black
                        }
                case "TungkunRailTransit":
                        switch name {
                        case "1 號線": Color(rgb: 0x3886BD)
                        case "2 號線": Color(rgb: 0xCE0010)
                        default: Color.black
                        }
                case "ShamChunMetro":
                        /// Source: https://zh.wikipedia.org/zh-hk/Template:深圳地鐵顏色/doc
                        switch name {
                        case "1 號線": Color(rgb: 0x00AB39)
                        case "2 號線": Color(rgb: 0xDB6D1C)
                        case "3 號線": Color(rgb: 0x00A2E1)
                        case "4 號線": Color(rgb: 0xDC241F)
                        case "5 號線": Color(rgb: 0x9950B2)
                        case "6 號線": Color(rgb: 0x3ABCA8)
                        case "6 號線・支線": Color(rgb: 0x037776)
                        case "7 號線": Color(rgb: 0x0035AD)
                        case "8 號線": Color(rgb: 0xDB6D1C)
                        case "9 號線": Color(rgb: 0x846E74)
                        case "10 號線": Color(rgb: 0xF8779E)
                        case "11 號線": Color(rgb: 0x6A1D44)
                        case "12 號線": Color(rgb: 0xA192B2)
                        case "13 號線": Color(rgb: 0xDE7C00)
                        case "14 號線": Color(rgb: 0xF2C75C)
                        case "16 號線": Color(rgb: 0x1E22AA)
                        case "20 號線": Color(rgb: 0x88DBDF)
                        default: Color.black
                        }
                default:
                        Color.black
                }
        }
        var foregroundColor: Color {
                switch (group, name) {
                case ("CantonMetro", "1 號線"): Color.black
                case ("ShamChunMetro", "20 號線"): Color.black
                default: Color.white
                }
        }
}
