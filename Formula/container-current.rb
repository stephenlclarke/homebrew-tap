class ContainerCurrent < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://apple.github.io/container/documentation/"
  url "https://github.com/stephenlclarke/container-compose/releases/download/current/container-current-02a076b20aa3-arm64.tar.gz"
  version "current.1085.02a076b20aa3"
  sha256 "a48505aca66f8e8e4f981edcd11d75a578d04d23a511a747f0366eb1857d1548"
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
    compose_plugin = HOMEBREW_PREFIX/"opt/container-compose-current/libexec/container-plugins/compose"
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
      This formula installs the current build prebuilt package asset:
        container-current-02a076b20aa3-arm64.tar.gz

      If stephenlclarke/tap/container-compose-current is installed, this formula links
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
    assert_match "List running containers", shell_output("#{bin}/container list --help")
  end
end
