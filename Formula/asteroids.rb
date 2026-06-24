class Asteroids < Formula
  desc "Native macOS vector arcade shooter built with Swift and SpriteKit"
  homepage "https://github.com/stephenlclarke/asteroids"
  head "https://github.com/stephenlclarke/asteroids.git", branch: "main"

  depends_on xcode: ["15.0", :build]
  depends_on macos: :ventura

  def install
    system "swift", "build", "--configuration", "release", "--disable-sandbox"

    app = libexec/"Asteroids.app"
    executable = app/"Contents/MacOS/Asteroids"
    (app/"Contents/MacOS").mkpath
    cp buildpath/".build/release/Asteroids", executable
    chmod 0755, executable

    (app/"Contents/Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>Asteroids</string>
        <key>CFBundleIdentifier</key>
        <string>com.stephenlclarke.Asteroids</string>
        <key>CFBundleName</key>
        <string>Asteroids</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>LSMinimumSystemVersion</key>
        <string>13.0</string>
        <key>NSPrincipalClass</key>
        <string>NSApplication</string>
      </dict>
      </plist>
    PLIST

    (bin/"asteroids").write <<~EOS
      #!/bin/bash
      exec /usr/bin/open -n "#{opt_libexec}/Asteroids.app" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Launch Asteroids with:
        asteroids

      Or open the app bundle directly:
        open "#{opt_libexec}/Asteroids.app"
    EOS
  end

  test do
    assert_predicate libexec/"Asteroids.app/Contents/MacOS/Asteroids", :executable?
    assert_match "com.stephenlclarke.Asteroids", (libexec/"Asteroids.app/Contents/Info.plist").read
  end
end
