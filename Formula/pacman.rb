class Pacman < Formula
  desc "Native Rust Pac-Man implementation rendered with wgpu"
  homepage "https://github.com/stephenlclarke/pacman"
  url "https://github.com/stephenlclarke/pacman/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "8a0d77c95e87c55cc7a6a238e6f4aecd4d8a7084f070a548c5ac27851b458b2a"
  head "https://github.com/stephenlclarke/pacman.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release", "--locked"
    bin.install "target/release/pacman"
  end

  test do
    assert_predicate bin/"pacman", :executable?
  end
end
