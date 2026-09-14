class ContainerCurrent < Formula
  desc "Create and run Linux containers using lightweight virtual machines"
  homepage "https://apple.github.io/container/documentation/"
  url "https://github.com/stephenlclarke/container-compose/releases/download/current-d13695a1e68887d18edcc9b153e8a94216d46eab/container-current-d13695a1e688-arm64.tar.gz"
  version "current.1251.d13695a1e688"
  sha256 "cf803d87294a6f3f6a0aece12ddf306d6b828c016cfe8c706b9bfb2a05b2b9c8"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    bin.install "bin/container"
    bin.install "bin/container-apiserver"
    bin.install "bin/container-engine"
    bin.install "bin/update-container.sh"
    bin.install "bin/uninstall-container.sh"
    libexec.install "libexec/ensure-container-stopped.sh"
    libexec.install "libexec/container"

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
        container-current-d13695a1e688-arm64.tar.gz

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
    assert_predicate bin/"container-engine", :executable?
    assert_predicate libexec/"container/helpers/container-semantic-helper", :executable?
    assert_path_exists libexec/"container/services/journald/container-journald-service.oci.tar"
    assert_path_exists libexec/"container/services/gelf/container-gelf-service.oci.tar"
  end
end
