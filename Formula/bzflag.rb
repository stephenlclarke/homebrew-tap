class Bzflag < Formula
  desc "Native macOS BZFlag tank-battle remake built with SwiftUI"
  homepage "https://github.com/stephenlclarke/bzflag"
  head "https://github.com/stephenlclarke/bzflag.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--configuration", "release", "--disable-sandbox"

    app = libexec/"BZFlag.app"
    executable = app/"Contents/MacOS/BZFlagApp"
    (app/"Contents/MacOS").mkpath
    cp buildpath/".build/release/BZFlagApp", executable
    chmod 0755, executable

    (app/"Contents/Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>BZFlagApp</string>
        <key>CFBundleIdentifier</key>
        <string>com.stephenlclarke.bzflag</string>
        <key>CFBundleName</key>
        <string>BZFlag</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>LSMinimumSystemVersion</key>
        <string>14.0</string>
        <key>NSPrincipalClass</key>
        <string>NSApplication</string>
      </dict>
      </plist>
    PLIST

    (bin/"bzflag").write <<~EOS
      #!/bin/bash
      exec /usr/bin/open -n "#{opt_libexec}/BZFlag.app" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Launch BZFlag with:
        bzflag

      Or open the app bundle directly:
        open "#{opt_libexec}/BZFlag.app"
    EOS
  end

  test do
    assert_predicate libexec/"BZFlag.app/Contents/MacOS/BZFlagApp", :executable?
    assert_match "com.stephenlclarke.bzflag", (libexec/"BZFlag.app/Contents/Info.plist").read
  end
end
