class ContainerRelease < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://apple.github.io/container/documentation/"
  url "https://github.com/stephenlclarke/container/releases/download/homebrew-release/container-homebrew-release-release-arm64.tar.gz"
  version "release-release-38fb99862ac0"
  sha256 "0209ec02d4e95fcbe68598b8f782a0275937f15c171e166d8e7ee7767f3cc678"
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
    compose_plugin = HOMEBREW_PREFIX/"opt/container-compose-release/libexec/container-plugins/compose"
    plugin_dir = opt_prefix/"libexec/container-plugins"
    if compose_plugin.exist?
      plugin_dir.mkpath
      plugin_link = plugin_dir/"compose"
      if plugin_link.symlink? || plugin_link.file?
        rm plugin_link
      elsif plugin_link.directory?
        rm_r plugin_link
      end
      ln_s compose_plugin, plugin_link
    end
  end

  def caveats
    <<~EOS
      This formula installs the release lane prebuilt package asset:
        container-homebrew-release-release-arm64.tar.gz

      If stephenlclarke/tap/container-compose-release is installed, this formula links
      the Compose plugin into:
        #{opt_prefix}/libexec/container-plugins/compose
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
