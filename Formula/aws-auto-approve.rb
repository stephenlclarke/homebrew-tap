class AwsAutoApprove < Formula
  desc "Native WebKit helper for locally initiated AWS SSO approval"
  homepage "https://github.com/stephenlclarke/aws-auto-approve"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/stephenlclarke/aws-auto-approve/releases/download/v0.2.1/aws-auto-approve-0.2.1-macos-arm64.tar.gz"
    sha256 "1179da37547657eed018fafd57a12931a4ad6451b4987e1c41443683ace57a23"
  else
    url "https://github.com/stephenlclarke/aws-auto-approve/releases/download/v0.2.1/aws-auto-approve-0.2.1-macos-x86_64.tar.gz"
    sha256 "dfaf7209ed76d61653c4f15b8ff8ec904b27c9819a9640f46cd52adcc3345621"
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
