Jyutping
======

<a href="https://t.me/jyutping">
        <img src="images/badge-telegram.png" alt="Telegram" width="150"/>
</a>
<a href="https://jq.qq.com/?k=4PR17m3t">
        <img src="images/badge-qq.png" alt="QQ" width="150"/>
</a>
<a href="https://twitter.com/JyutpingApp">
        <img src="images/badge-twitter.png" alt="Twitter" width="150"/>
</a>
<a href="https://www.instagram.com/jyutping_app">
        <img src="images/badge-instagram.png" alt="Instagram" width="150"/>
</a>
<br>
<br>

Cantonese Keyboard for iOS & macOS.

粵拼輸入法。採用 [香港語言學學會粵語拼音方案](https://jyutping.org/jyutping) (粵拼 / Jyutping)，兼容各種習慣拼寫串法。

## iOS & iPadOS

<a href="https://apps.apple.com/hk/app/id1509367629">
        <img src="images/badge-app-store-download.svg" alt="App Store badge" width="150"/>
</a>
<br>
<a href="https://apps.apple.com/hk/app/id1509367629">
        <img src="images/qrcode-app-store.png" alt="App Store QR Code" width="150"/>
</a>
<br>
<br>
<a href="https://testflight.apple.com/join/AG1Zkx7G">
        <img src="images/badge-testflight.png" alt="TestFlight badge" width="150"/>
</a>
<br>
<a href="https://testflight.apple.com/join/AG1Zkx7G">
        <img src="images/qrcode-testflight.png" alt="TestFlight QR Code" width="150"/>
</a>
<br>
<br>
兼容系統： iOS / iPadOS 15.0+

## macOS
由於 [第三方輸入法無法上架 Mac App Store](https://developer.apple.com/forums/thread/134115) ，請前往 [網棧](https://jyutping.app/mac) 或者 [Releases](https://github.com/yuetyam/jyutping/releases) 䈎面下載安裝。

安裝指引： [macOS 粵拼輸入法下載安裝指引](https://jyutping.app/mac)  
常問問題： [常問問題（FAQ）](https://jyutping.app/faq)  
兼容系統： macOS 12 Monterey 或者更高

## 擷屏（Screenshots）
<img src="images/screenshot.png" alt="iPhone screenshots" width="440"/>
<br>
<img src="images/screenshot-mac.png" alt="macOS screenshots" width="440"/>


## 如何構建（How to build）
前置要求（Build requirements）
- macOS 14.0+
- Xcode 15.4+

倉庫體積比較大，建議加 `--depth` 來 clone。
~~~bash
git clone --depth 1 https://github.com/yuetyam/jyutping.git
~~~
先構建數據庫 (Prepare database)。
~~~bash
# cd path/to/jyutping
cd ./Modules/Preparing/
swift run -c release
~~~
跟住用 Xcode 開啓 `Jyutping.xcodeproj` 即可。

成個工程(project)包含 `Jyutping`, `Keyboard`, `InputMethod` 三個目標(target)。  
`Jyutping` 係正常App，`Keyboard` 係 iOS Keyboard Extension，`InputMethod` 係 macOS 輸入法。

注意事項: 毋好直接 Run `InputMethod`，只可以 Build 或 [Archive](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases#Create-an-archive-of-your-app)

如果要自己本機測試 Mac 輸入法，請將 Archive & Export 出來嘅 Jyutping.app 輸入法程式放入 `/Library/Input\ Methods/` 檔案夾。  
如果替換舊有 Jyutping.app 輸入法箇陣，彈提示話佢運行緊、無法替換，可以去 Terminal（終端） 用以下命令將佢結束運行：
~~~bash
osascript -e 'tell application id "org.jyutping.inputmethod.Jyutping" to quit'
~~~

## 多謝支持（Support this project）
<a href="https://ko-fi.com/zheung">
        <img src="images/buy-me-a-coffee.png" alt="Ko-fi, buy me a coffee" width="180"/>
</a>
<br>
<a href="https://patreon.com/bingzheung">
        <img src="images/become-a-patron.png" alt="Patron" width="180"/>
</a>
<br>
<br>
<img src="images/sponsor.jpg" alt="WeChat Sponsor" width="180"/>
