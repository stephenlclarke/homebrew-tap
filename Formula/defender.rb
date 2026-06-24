class Defender < Formula
  desc "Native Rust reimplementation of Williams Defender"
  homepage "https://github.com/stephenlclarke/defender"
  head "https://github.com/stephenlclarke/defender.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release", "--locked"
    bin.install "target/release/defender"
  end

  test do
    assert_predicate bin/"defender", :executable?
  end
end
