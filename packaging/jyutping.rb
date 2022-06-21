cask "jyutping" do
  version "0.19.0"
  sha256 "a8444ba17624820f3d4152561dc93cd8265911c217f08897088017875f832426"

  url "https://github.com/yuetyam/jyutping/releases/download/#{version}/Jyutping-IME-Mac-v#{version}.zip",
      verified: "github.com/yuetyam/jyutping/"
  name "Jyutping"
  desc "Cantonese Jyutping Input Method"
  homepage "https://jyutping.org/"

  depends_on macos: ">= :monterey"

  pkg "Jyutping.pkg"

  uninstall pkgutil: "org.jyutping.inputmethod.Jyutping",
            delete:  "/Library/Input Methods/Jyutping.app"

  zap trash: [
    "~/Library/Application Scripts/org.jyutping.inputmethod.Jyutping",
    "~/Library/Containers/org.jyutping.inputmethod.Jyutping",
    "~/Library/Preferences/org.jyutping.inputmethod.Jyutping.plist",
  ]
end
