class Battlezone < Formula
  desc "Native Rust Battlezone implementation for Kitty graphics terminals"
  homepage "https://github.com/stephenlclarke/battlezone"
  url "https://github.com/stephenlclarke/battlezone/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "ea1e749ccf69ef0568611268808d9b5d27ae4d9efc171e231b04b98536f18461"
  head "https://github.com/stephenlclarke/battlezone.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release", "--locked"
    bin.install "target/release/battlezone"
  end

  test do
    assert_predicate bin/"battlezone", :executable?
  end
end
