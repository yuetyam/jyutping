cask "jyutping" do
  version "0.18.0"
  sha256 "2e1d2fdad5b59abadacdadbb2182932a560b62d0f222daefba47661c57beef55"

  url "https://github.com/yuetyam/jyutping/releases/download/#{version}/Jyutping-IME-Mac-v#{version}.zip",
      verified: "github.com/yuetyam/jyutping/"
  name "Jyutping"
  desc "Cantonese Jyutping Input Method"
  homepage "https://jyutping.org"

  depends_on macos: ">= :monterey"

  auto_updates false

  pkg "Jyutping.pkg"

  uninstall pkgutil: "org.jyutping.inputmethod.Jyutping",
            delete:  "~/Library/Input Methods/Jyutping.app"

  zap trash: [
    "~/Library/Application Scripts/org.jyutping.inputmethod.Jyutping",
    "~/Library/Containers/org.jyutping.inputmethod.Jyutping",
    "~/Library/Preferences/org.jyutping.inputmethod.Jyutping.plist",
  ]
end
