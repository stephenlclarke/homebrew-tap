class AwsAutoApprove < Formula
  desc "Native WebKit helper for locally initiated AWS SSO approval"
  homepage "https://github.com/stephenlclarke/aws-auto-approve"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/stephenlclarke/aws-auto-approve/releases/download/v0.2.0/aws-auto-approve-0.2.0-macos-arm64.tar.gz"
    sha256 "ce339e18aedc1f0ffdfa07fa64ecf9b73bd1e3fbdc5c810eb0e1b0bd488c0e88"
  else
    url "https://github.com/stephenlclarke/aws-auto-approve/releases/download/v0.2.0/aws-auto-approve-0.2.0-macos-x86_64.tar.gz"
    sha256 "0b3458aee39d429238375a95000c2584386e3be7882fdfffabda9b05eb0bd681"
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
    app = libexec/"AWS Auto Approve.app"
    system "/usr/bin/codesign", "--verify", "--deep", "--strict", app
    system "/usr/sbin/spctl", "--assess", "--type", "execute", app
    assert_match "Granted is not used", shell_output("#{bin}/aws-auto-approve-login --help")
    assert_match "Usage: aws-auto-approve", shell_output("#{bin}/aws-auto-approve --help")
  end
end
