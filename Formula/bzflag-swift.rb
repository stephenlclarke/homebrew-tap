class BzflagSwift < Formula
  desc "Native macOS SwiftUI implementation of BZFlag"
  homepage "https://github.com/stephenlclarke/bzflag-swift"
  head "https://github.com/stephenlclarke/bzflag-swift.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--configuration", "release", "--disable-sandbox"

    app = libexec/"BZFlagSwift.app"
    executable = app/"Contents/MacOS/BZFlagSwift"
    (app/"Contents/MacOS").mkpath
    cp buildpath/".build/release/BZFlagSwift", executable
    chmod 0755, executable

    (app/"Contents/Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>BZFlagSwift</string>
        <key>CFBundleIdentifier</key>
        <string>com.stephenlclarke.bzflag-swift</string>
        <key>CFBundleName</key>
        <string>BZFlag Swift</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>LSMinimumSystemVersion</key>
        <string>14.0</string>
        <key>NSPrincipalClass</key>
        <string>NSApplication</string>
      </dict>
      </plist>
    PLIST

    (bin/"bzflag-swift").write <<~EOS
      #!/bin/bash
      exec /usr/bin/open -n "#{opt_libexec}/BZFlagSwift.app" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Launch BZFlag Swift with:
        bzflag-swift

      Or open the app bundle directly:
        open "#{opt_libexec}/BZFlagSwift.app"
    EOS
  end

  test do
    assert_predicate libexec/"BZFlagSwift.app/Contents/MacOS/BZFlagSwift", :executable?
    assert_match "com.stephenlclarke.bzflag-swift", (libexec/"BZFlagSwift.app/Contents/Info.plist").read
  end
end
