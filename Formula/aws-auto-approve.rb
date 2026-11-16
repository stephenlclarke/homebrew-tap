class AwsAutoApprove < Formula
  desc "Native WebKit helper for locally initiated AWS SSO approval"
  homepage "https://github.com/stephenlclarke/aws-auto-approve"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/stephenlclarke/aws-auto-approve/releases/download/v0.1.1/aws-auto-approve-0.1.1-macos-arm64.tar.gz"
    sha256 "36c900e7a9b0c8861ad1d576c0f8f620f05d505ba455f58837e31b6348d32c23"
  else
    url "https://github.com/stephenlclarke/aws-auto-approve/releases/download/v0.1.1/aws-auto-approve-0.1.1-macos-x86_64.tar.gz"
    sha256 "45d830143cf3c3f6382341e084b40c8673534ed7f9ac578cac9696940647a571"
  end

  depends_on "awscli"
  depends_on :macos
  on_macos do
    depends_on macos: :sonoma
  end

  skip_clean "libexec/AWS Auto Approve.app"

  def install
    libexec.install "AWS Auto Approve.app"
    bin.install_symlink libexec/"AWS Auto Approve.app/Contents/MacOS/aws-auto-approve"
    bin.install "Integration/aws-auto-approve-login"
    zsh_completion.install "Completions/_aws-auto-approve", "Completions/_aws-auto-approve-login"
  end

  test do
    assert_match "Granted is not used", shell_output("#{bin}/aws-auto-approve-login --help")
    assert_match "Usage: aws-auto-approve", shell_output("#{bin}/aws-auto-approve --help")
  end
end
