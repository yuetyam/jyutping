cask "jyutping" do
  version "0.21.0"
  sha256 "da6b78f06489380d0aa23bc0ad77774eabc790b922b3bf33197205ce1e7cfee1"

  url "https://github.com/yuetyam/jyutping/releases/download/#{version}/Jyutping-v#{version}-Mac-IME.pkg.zip",
      verified: "github.com/yuetyam/jyutping/"
  name "Jyutping"
  desc "Cantonese Jyutping Input Method"
  homepage "https://jyutping.app/"

  depends_on macos: ">= :monterey"

  pkg "Jyutping-v#{version}-Mac-IME.pkg"

  uninstall pkgutil: "org.jyutping.inputmethod.Jyutping",
            delete:  "/Library/Input Methods/Jyutping.app"

  zap trash: [
    "~/Library/Application Scripts/org.jyutping.inputmethod.Jyutping",
    "~/Library/Containers/org.jyutping.inputmethod.Jyutping",
    "~/Library/Preferences/org.jyutping.inputmethod.Jyutping.plist",
  ]
end
