class Container < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://apple.github.io/container/documentation/"
  url "https://github.com/stephenlclarke/container/releases/download/homebrew-main-178-a4fb715bfa97/container-homebrew-main-release-arm64.tar.gz"
  version "main-release.178.a4fb715bfa97"
  sha256 "7567d7a1ef07723a50265df367da6d4f05c8be05e39607567d77bec6973d209e"
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
    compose_plugin = HOMEBREW_PREFIX/"opt/container-compose/libexec/container-plugins/compose"
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
      This formula installs the main lane prebuilt package asset:
        container-homebrew-main-release-arm64.tar.gz

      If stephenlclarke/tap/container-compose is installed, this formula links
      the Compose plugin into:
        #{opt_prefix}/libexec/container-plugins/compose
    EOS
  end

  service do
    run [opt_bin/"container", "system", "start"]
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
