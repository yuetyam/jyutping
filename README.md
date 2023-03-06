Jyutping
======

<a href="https://t.me/jyutping">
        <img src="images/telegram.png" alt="Telegram" width="150"/>
</a>　<a href="https://twitter.com/JyutpingApp">
        <img src="images/twitter.png" alt="Twitter" width="150"/>
</a>　<a href="https://www.instagram.com/jyutping_app">
        <img src="images/instagram.png" alt="Instagram" width="150"/>
</a>
<br>
<br>

Cantonese Jyutping Keyboard for iOS & macOS.

粵拼輸入法。採用香港語言學學會粵語拼音方案（粵拼，Jyutping）。詞庫碼表來自 CanCLD [Rime-Cantonese](https://github.com/rime/rime-cantonese)

## iOS & iPadOS

<a href="https://apps.apple.com/hk/app/id1509367629">
        <img src="images/app-store-badge.svg" alt="App Store badge" width="150"/>
</a>
<br>
<br>

<a href="https://apps.apple.com/hk/app/id1509367629">
        <img src="images/app-store-link-qrcode.png" alt="App Store QR Code" width="150"/>
</a>
<br>
<br>

兼容性： iOS / iPadOS 15.0+

## macOS
由於 Mac App Store 毋接受輸入法上架，請前往 [網站](https://jyutping.app) 或者 [Releases](https://github.com/yuetyam/jyutping/releases) 䈎面下載安裝。

請注意： 安裝／更新輸入法之後需要登出電腦再登入，或者重啓電腦。

兼容性： macOS 12 Monterey 或者更高

## 擷屏（Screenshots）
<img src="images/screenshot.png" alt="iPhone screenshots" width="440"/>
<br>
<img src="images/screenshot-mac.png" alt="macOS screenshots" width="440"/>


## 如何構建（How to build）
#### 前置要求（Build requirements）
- macOS 13.0+
- Xcode 14.2+

用 Xcode 開啓 `Jyutping/Jyutping.xcodeproj` 即可。

成個項目(project)包含 `Jyutping`, `Keyboard`, `InputMethod` 三個目標(target)。

`Jyutping` 係正常App，`Keyboard` 係 iOS Keyboard Extension，`InputMethod` 係 macOS 輸入法。

**注意事項**: 請勿 Run `InputMethod`，只可以 Build 或 Archive。

## 鳴謝（Credits）
- [Rime-Cantonese](https://github.com/rime/rime-cantonese)
- [OpenCC](https://github.com/BYVoid/OpenCC)

## Support this project
<a href="https://patreon.com/ososoio">
        <img src="images/become-a-patron.png" alt="patreon" width="150"/>
</a>
<br>
<a href="https://ko-fi.com/ososoio">
        <img src="images/buy-me-a-coffee.png" alt="ko-fi, buy me a coffee" width="150"/>
</a>
