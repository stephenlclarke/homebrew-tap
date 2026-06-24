class FixdecoderGo < Formula
  desc "Go implementation of the FIX log prettifier and dictionary explorer"
  homepage "https://github.com/stephenlclarke/fixdecoder_go"
  url "https://github.com/stephenlclarke/fixdecoder_go/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2d0962a3c74d09e012292b009f5178447df3bdb1b6244b67991bf29de24404fa"
  license "AGPL-3.0-only"
  head "https://github.com/stephenlclarke/fixdecoder_go.git", branch: "main"

  depends_on "go" => :build

  def install
    version_value = build.head? ? "HEAD" : "v#{version}"
    ldflags = %W[
      -s -w
      -X main.Version=#{version_value}
      -X main.Branch=homebrew
      -X main.Sha=homebrew
      -X main.GitUrl=#{homepage}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"fixdecoder-go", "./cmd/fixdecoder"
  end

  test do
    assert_match "Available FIX Dictionaries", shell_output("#{bin}/fixdecoder-go -info")
  end
end
