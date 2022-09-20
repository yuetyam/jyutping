cask "jyutping" do
  version "0.20.0"
  sha256 "da6ba7e31340706fba137773256030df8b4b1bf25ee7c06edea30c40bf3d3762"

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
