class FixdecoderZig < Formula
  desc "Zig implementation of the FIX log prettifier and dictionary explorer"
  homepage "https://github.com/stephenlclarke/fixdecoder_zig"
  license "AGPL-3.0-only"
  head "https://github.com/stephenlclarke/fixdecoder_zig.git", branch: "main"

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseFast", "-Dapp-version=0.1.0"
    bin.install "zig-out/bin/fixdecoder" => "fixdecoder-zig"
  end

  test do
    assert_match "fixdecoder", shell_output("#{bin}/fixdecoder-zig --version")
  end
end
