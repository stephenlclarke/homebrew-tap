class Battlezone < Formula
  desc "Native Rust Battlezone implementation rendered with wgpu"
  homepage "https://github.com/stephenlclarke/battlezone"
  url "https://github.com/stephenlclarke/battlezone/archive/457237526a80061a9469f227b98cad090616c44d.tar.gz"
  version "1.0.0"
  sha256 "62997201e99d67602b08490f65b1beb548a3e2ad267ad1f05757bfb4ee2077b5"
  revision 1
  head "https://github.com/stephenlclarke/battlezone.git", branch: "develop"

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
  end

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "launches the game in a wgpu window", shell_output("#{bin}/battlezone --help")
    assert_match "battlezone 1.0.0", shell_output("#{bin}/battlezone --version")
  end
end
