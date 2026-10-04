class Pacman < Formula
  desc "Native Rust Pac-Man implementation rendered with wgpu"
  homepage "https://github.com/stephenlclarke/pacman"
  url "https://github.com/stephenlclarke/pacman/archive/cd49a1a0f407801cdc492ba61b4cdc5f8afb42c5.tar.gz"
  version "1.0.0"
  sha256 "5465b2e1503415d60964c3ae831c5145d8ba4273041e95ae6c6c134a2870ad60"
  revision 1
  head "https://github.com/stephenlclarke/pacman.git", branch: "wgpu"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "launches the game in a wgpu window", shell_output("#{bin}/pacman --help")
  end
end
