class ContainerRelease < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://apple.github.io/container/documentation/"
  url "https://github.com/stephenlclarke/container/releases/download/homebrew-release/container-homebrew-release-release-arm64.tar.gz"
  version "release-release-5c0a92e14a75"
  sha256 "2e1805c148b8e9158a546b9dbfbf30eb34e5e0a8f2d663f1a0bc02078e8316a4"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    bin.install "bin/container"
    bin.install "bin/container-apiserver"
    bin.install "bin/update-container.sh"
    bin.install "bin/uninstall-container.sh"
    libexec.install "libexec/ensure-container-stopped.sh"
    (libexec/"container").install "libexec/container/plugins"

    generate_completions_from_executable bin/"container", "--generate-completion-script"

    bin.env_script_all_files libexec/"bin", CONTAINER_INSTALL_ROOT: opt_prefix
  end

  def post_install
    system libexec/"ensure-container-stopped.sh", "-a"
  end

  def caveats
    <<~EOS
      This formula installs the latest release prebuilt release asset:
        container-homebrew-release-release-arm64.tar.gz
    EOS
  end

  service do
    run [opt_bin/"container", "system", "start"]
    keep_alive true
    working_dir var
    log_path var/"log/container.log"
    error_log_path var/"log/container.log"
  end

  test do
    assert_match "container CLI version", shell_output("#{bin}/container --version")
    assert_match(/Error: (?:interrupted: ")?internalError: "failed to list containers"/,
                 shell_output("#{bin}/container list 2>&1", 1))
  end
end
