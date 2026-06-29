class ContainerComposeRelease < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/homebrew-release/container-compose-plugin-release-release-arm64.tar.gz"
  version "release-release-ab8aae62214e"
  sha256 "b1d3c1042809afed82e0aff1eba9190856584e4a2a2eb4da6e758781de969728"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on "stephenlclarke/tap/container-release"

  def install
    plugin = libexec/"container-plugins/compose"
    payload = (buildpath/"compose").directory? ? Dir["compose/*"] : Dir["*"]
    plugin.install payload

    bin.install_symlink plugin/"bin/compose" => "container-compose"
  end

  def post_install
    container_opt = HOMEBREW_PREFIX/"opt/container-release"
    return unless container_opt.exist?

    plugin_dir = container_opt/"libexec/container-plugins"
    plugin_dir.mkpath
    FileUtils.rm_rf plugin_dir/"compose"
    FileUtils.ln_s opt_libexec/"container-plugins/compose", plugin_dir/"compose"
  end

  def caveats
    <<~EOS
      The plugin is installed under:
        #{opt_libexec}/container-plugins/compose

      The formula links the plugin into the Homebrew container-release install root:
        $(brew --prefix stephenlclarke/tap/container-release)/libexec/container-plugins/compose

      Restart stephenlclarke/tap/container-release after installing or upgrading this plugin:
        brew services restart stephenlclarke/tap/container-release

      This formula installs the release lane prebuilt package asset:
        container-compose-plugin-release-release-arm64.tar.gz
    EOS
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/container-compose version --short")
    assert_path_exists libexec/"container-plugins/compose/config.toml"
    assert_predicate libexec/"container-plugins/compose/resources/compose-normalizer", :executable?
  end
end
