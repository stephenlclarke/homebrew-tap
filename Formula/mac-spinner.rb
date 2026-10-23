# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Stephen Clarke

class MacSpinner < Formula
  desc "Small command-line spinner for macOS terminal workflows"
  homepage "https://github.com/stephenlclarke/mac-spinner"
  version "0.1.0"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/stephenlclarke/mac-spinner/releases/download/v0.1.0/mac-spinner-arm64.tar.gz"
    sha256 "d6d066a4b10f3acaf368fc43c64e044a7971e3fb2cc2d0fd10eab508742ca170"
  else
    url "https://github.com/stephenlclarke/mac-spinner/releases/download/v0.1.0/mac-spinner-x86_64.tar.gz"
    sha256 "41c5e08a80ee2efaa04e24cb4e7eddbc9b1d9a5926e26145eeb93200d17cadc3"
  end

  depends_on macos: :ventura

  def install
    bin.install Dir["**/bin/mac-spinner"].first
  end

  test do
    assert_match "brew smoke", shell_output("#{bin}/mac-spinner --message 'brew smoke' --pending")
  end
end
