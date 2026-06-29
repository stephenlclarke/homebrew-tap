class ContainerCompose < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/homebrew-main/container-compose-plugin-main-release-arm64.tar.gz"
  version "main-release-7bdc5f27b899"
  sha256 "67988b7761df9cfec5f3a8ababe591a7b5757c11bad1bbf43a7f516608853536"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on "stephenlclarke/tap/container"

  def install
    plugin = libexec/"container-plugins/compose"
    payload = (buildpath/"compose").directory? ? Dir["compose/*"] : Dir["*"]
    plugin.install payload

    bin.install_symlink plugin/"bin/compose" => "container-compose"
  end

  def post_install
    container_opt = HOMEBREW_PREFIX/"opt/container"
    return unless container_opt.exist?

    plugin_dir = container_opt/"libexec/container-plugins"
    plugin_dir.mkpath
    rm_rf plugin_dir/"compose"
    ln_s opt_libexec/"container-plugins/compose", plugin_dir/"compose"
  end

  def caveats
    <<~EOS
      The plugin is installed under:
        #{opt_libexec}/container-plugins/compose

      The formula links the plugin into the Homebrew container install root:
        $(brew --prefix stephenlclarke/tap/container)/libexec/container-plugins/compose

      Restart stephenlclarke/tap/container after installing or upgrading this plugin:
        brew services restart stephenlclarke/tap/container

      This formula installs the main lane prebuilt package asset:
        container-compose-plugin-main-release-arm64.tar.gz
    EOS
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/container-compose version --short")
    assert_path_exists libexec/"container-plugins/compose/config.toml"
    assert_predicate libexec/"container-plugins/compose/resources/compose-normalizer", :executable?
  end
end
