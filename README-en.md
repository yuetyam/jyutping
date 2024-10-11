README in [粵語(Cantonese)](README.md) | [普通話(Mandarin)](README-cmn.md)

Jyutping
======

<a href="https://t.me/jyutping">
        <img src="images/badge-telegram.png" alt="Telegram" width="150"/>
</a>
<a href="https://x.com/JyutpingApp">
        <img src="images/badge-twitter.png" alt="X (formerly Twitter)" width="150"/>
</a>
<a href="https://www.threads.net/@jyutping_app">
        <img src="images/badge-threads.png" alt="Threads" width="150"/>
</a>
<a href="https://www.instagram.com/jyutping_app">
        <img src="images/badge-instagram.png" alt="Instagram" width="150"/>
</a>
<a href="https://jq.qq.com/?k=4PR17m3t">
        <img src="images/badge-qq.png" alt="QQ" width="150"/>
</a>
<br>
<br>

Cantonese Keyboard for iOS & macOS adopts the [LSHK Jyutping scheme](https://jyutping.org/jyutping) and supports common habitual spellings.

Feature highlights:
- Full support for Jyutping input.
- Abbreviated input with Jyutping initials.
- Accurate input with Jyutping tones.
- Traditional / Simplified characters.
- Reverse Lookup with Cangjie, Quick(Sucheng), Stroke or Mandarin Pinyin.
- Jyutping hints for candidates.
- Emoji suggestions.
- Easy ways to Copy, Cut, Paste and moving cursor backward/forward.
- Audio and Haptic feedbacks.

Jyutping for Android: [yuetyam/jyutping-android](https://github.com/yuetyam/jyutping-android)

## Screenshots
<img src="images/screenshot.png" alt="iPhone screenshots" width="300"/>
<br>
<img src="images/screenshot-mac.png" alt="macOS screenshots" width="300"/>

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
Compatibility: iOS / iPadOS 15.0+

## macOS
Due to [limitations imposed by the Mac App Store on third-party input methods](https://developer.apple.com/forums/thread/134115) , it's impossible to distribute this input method through the Mac App Store. Please visit our [website](https://jyutping.app) to download it or install it via [Homebrew](https://jyutping.app/mac/homebrew) .

Compatibility: macOS 12 Monterey or higher.  
Options: Press <kbd>Control</kbd> + <kbd>Shift</kbd> + <kbd>`</kbd> (below the esc key) will display an options window.  
FAQ: [FAQ](https://jyutping.app/faq)

## How to build
Build requirements
- macOS 15.0+
- Xcode 16.0+

Clone with `--depth` to reduce code size:
~~~bash
git clone --depth 1 https://github.com/yuetyam/jyutping.git
~~~
Prepare databases:
~~~bash
# cd path/to/jyutping
cd ./Modules/Preparing/
swift run -c release
~~~
Then use Xcode to open `Jyutping.xcodeproj` .

This project contains three tergets, `Jyutping` (Main App), `Keyboard` (iOS) and `InputMethod` (macOS).

**Note**: Do not *Run* `InputMethod` , it can only be *Build* or [Archive](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases#Create-an-archive-of-your-app)

If you want to use your Mac to test the input method, you need to place the *Archive & Export* Jyutping.app to `/Library/Input\ Methods/` .

When replacing the old Jyutping.app, Finder may prompt a message indicating that it's running. You can terminate it using this command:
~~~bash
osascript -e 'tell application id "org.jyutping.inputmethod.Jyutping" to quit'
~~~

## Credits
- [Rime-Cantonese](https://github.com/rime/rime-cantonese) (Cantonese Lexicon)
- [OpenCC](https://github.com/BYVoid/OpenCC) (Traditional-Simplified Character Conversion)
- [JetBrains](https://www.jetbrains.com/) (Licenses for Open Source Development)

## Thank you for your support
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
