class Maze < Formula
  desc "Native macOS maze generator and solver built with SwiftUI"
  homepage "https://github.com/stephenlclarke/maze"
  head "https://github.com/stephenlclarke/maze.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--configuration", "release", "--disable-sandbox"

    app = libexec/"Maze.app"
    executable = app/"Contents/MacOS/MazeApp"
    (app/"Contents/MacOS").mkpath
    cp buildpath/".build/release/MazeApp", executable
    chmod 0755, executable

    (app/"Contents/Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>MazeApp</string>
        <key>CFBundleIdentifier</key>
        <string>com.stephenlclarke.maze</string>
        <key>CFBundleName</key>
        <string>Maze</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>LSMinimumSystemVersion</key>
        <string>14.0</string>
        <key>NSPrincipalClass</key>
        <string>NSApplication</string>
      </dict>
      </plist>
    PLIST

    (bin/"maze").write <<~EOS
      #!/bin/bash
      exec /usr/bin/open -n "#{opt_libexec}/Maze.app" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Launch Maze with:
        maze

      Or open the app bundle directly:
        open "#{opt_libexec}/Maze.app"
    EOS
  end

  test do
    assert_predicate libexec/"Maze.app/Contents/MacOS/MazeApp", :executable?
    assert_match "com.stephenlclarke.maze", (libexec/"Maze.app/Contents/Info.plist").read
  end
end
