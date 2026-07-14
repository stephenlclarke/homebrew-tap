class Mazewar < Formula
  desc "Native macOS multiplayer maze game built with SwiftUI"
  homepage "https://github.com/stephenlclarke/mazewar"
  head "https://github.com/stephenlclarke/mazewar.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--configuration", "release", "--disable-sandbox"

    app = libexec/"Mazewar.app"
    executable = app/"Contents/MacOS/MazewarApp"
    (app/"Contents/MacOS").mkpath
    cp buildpath/".build/release/MazewarApp", executable
    chmod 0755, executable

    (app/"Contents/Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>MazewarApp</string>
        <key>CFBundleIdentifier</key>
        <string>com.stephenlclarke.mazewar</string>
        <key>CFBundleName</key>
        <string>Mazewar</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>LSMinimumSystemVersion</key>
        <string>14.0</string>
        <key>NSLocalNetworkUsageDescription</key>
        <string>Mazewar uses the local network to discover nearby players.</string>
        <key>NSBonjourServices</key>
        <array>
          <string>_maze-war._tcp</string>
        </array>
        <key>NSPrincipalClass</key>
        <string>NSApplication</string>
      </dict>
      </plist>
    PLIST

    (bin/"mazewar").write <<~EOS
      #!/bin/bash
      exec /usr/bin/open -n "#{opt_libexec}/Mazewar.app" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Launch Mazewar with:
        mazewar

      Or open the app bundle directly:
        open "#{opt_libexec}/Mazewar.app"
    EOS
  end

  test do
    assert_predicate libexec/"Mazewar.app/Contents/MacOS/MazewarApp", :executable?
    assert_match "com.stephenlclarke.mazewar", (libexec/"Mazewar.app/Contents/Info.plist").read
  end
end
