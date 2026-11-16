class AwsAutoApprove < Formula
  desc "Native WebKit helper for locally initiated AWS SSO approval"
  homepage "https://github.com/stephenlclarke/aws-auto-approve"
  version "0.1.0"
  license "MIT"

  on_arm do
    url "https://github.com/stephenlclarke/aws-auto-approve/releases/download/v0.1.0/aws-auto-approve-0.1.0-macos-arm64.tar.gz"
    sha256 "befb9ae8d60f9b0635147f9439434a78462b8e0f2c1869fdbe8c4ff031b2aaee"
  end

  on_intel do
    url "https://github.com/stephenlclarke/aws-auto-approve/releases/download/v0.1.0/aws-auto-approve-0.1.0-macos-x86_64.tar.gz"
    sha256 "1328e14a15dc01290173b6fb0ceabd94cf547a11c732654b4a52d1ee3d0f62b9"
  end

  depends_on :macos
  depends_on macos: :sonoma
  depends_on "awscli"

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
