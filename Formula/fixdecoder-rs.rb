class FixdecoderRs < Formula
  desc "Rust implementation of the FIX log prettifier and dictionary explorer"
  homepage "https://github.com/stephenlclarke/fixdecoder_rs"
  url "https://github.com/stephenlclarke/fixdecoder_rs/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d181a11c0390444ddcddd1dcaf3cdeece88814c41c5a4066136ca2b6a197896e"
  license "AGPL-3.0-only"
  head "https://github.com/stephenlclarke/fixdecoder_rs.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release", "--locked", "--workspace"
    bin.install "target/release/fixdecoder" => "fixdecoder-rs"
    bin.install "target/release/pcap2fix" => "pcap2fix-rs"
  end

  test do
    assert_match "fixdecoder", shell_output("#{bin}/fixdecoder-rs --version")
    assert_match "pcap2fix", shell_output("#{bin}/pcap2fix-rs --version")
  end
end
