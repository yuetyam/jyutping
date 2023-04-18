cask "jyutping" do
  version "0.24.0"
  sha256 "627253043408789066a8af463f84cb445d18dc2cc36ab9400843ceeaf6b58353"

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
