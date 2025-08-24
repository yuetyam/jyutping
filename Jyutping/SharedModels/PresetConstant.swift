struct PresetConstant {
        static let KeyboardIdentifier: String = "im.cantonese.CantoneseIM.Keyboard"
        static let SFPro: String = "SF Pro"
        static let Arial: String = "Arial"
        static let Inter: String = "Inter"
        static let Roboto: String = "Roboto"
        static let HelveticaNeue: String = "Helvetica Neue"
        static let WenKaiTC: String = "LXGW WenKai TC"
        static let WenKai: String = "LXGW WenKai"
        static let IMingCP: String = "I.MingCP"
        static let IMing: String = "I.Ming"
        static let primaryCJKVQueue: [String] = ["Shanggu Sans", "ChiuKong Gothic CL", "LXGW XiHei CL", "Source Han Sans K", "Noto Sans CJK KR", "Sarasa Gothic CL"]
        static let systemCJKVQueue: [String] = ["PingFang HK", "PingFang MO", "PingFang SC", "PingFang TC"]
        static let supplementaryCJKVQueue: [String] = ["Chiron Hei HK", "Source Han Sans HC", "Noto Sans CJK HK", "Noto Sans HK"]
        static let fallbackCJKVList: [String] = ["Plangothic P1", "Plangothic P2", "MiSans L3"]
}

struct BolderFont {
        static let SFPro: String = "SFPro-Medium"
        static let Inter: String = "Inter-Medium"
        static let Roboto: String = "Roboto-Medium"
        static let HelveticaNeue: String = "HelveticaNeue-Medium"
        static let primaryCJKVQueue: [String] = ["ShangguSans-Medium", "ChiuKongGothicCL-Medium", "SourceHanSansK-Medium", "NotoSerifCJKkr-Medium", "SarasaGothicCL-Medium"]
        static let systemCJKVQueue: [String] = ["PingFangHK-Medium", "PingFangMO-Medium", "PingFangSC-Medium", "PingFangTC-Medium"]
        static let supplementaryCJKVQueue: [String] = ["ChironHeiHK-Medium", "SourceHanSansHC-Medium", "NotoSansCJKhk-Medium", "NotoSansHK-Medium"]
}

extension PresetConstant {

static let etymologyNote: String = """
當前市面上盛傳嘅各種「粵語正字、本字」，大多數係穿鑿附會、郢書燕說、阿茂整餅，係錯嘅。
用字從衆、從俗更好，利於交流。唔好理會嗰啲老作。
"""

}
