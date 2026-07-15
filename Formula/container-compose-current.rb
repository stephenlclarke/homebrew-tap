class ContainerComposeCurrent < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/current/container-compose-plugin-current-f23ca16f03d5-arm64.tar.gz"
  version "current.f23ca16f03d5"
  sha256 "8009655e4b85be85f73e82462c217887d0c2f9f1493ac1c49aec3e30e6d4fc10"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on "stephenlclarke/tap/container-current"

  def install
    plugin = libexec/"container-plugins/compose"
    payload = (buildpath/"compose").directory? ? Dir["compose/*"] : Dir["*"]
    plugin.install payload

    bin.install_symlink plugin/"bin/compose" => "container-compose"
  end

  def caveats
    <<~EOS
      The plugin is installed under:
        #{opt_libexec}/container-plugins/compose

      The container formula owns the plugin registration link. Refresh it and
      restart stephenlclarke/tap/container-current after installing or upgrading this plugin:
        brew postinstall stephenlclarke/tap/container-current
        brew services restart stephenlclarke/tap/container-current

      This formula installs the current build prebuilt package asset:
        container-compose-plugin-current-f23ca16f03d5-arm64.tar.gz
    EOS
  end

  test do
    assert_match "0.6.70", shell_output("#{bin}/container-compose version --short")
    assert_path_exists libexec/"container-plugins/compose/config.toml"
    assert_predicate libexec/"container-plugins/compose/resources/compose-normalizer", :executable?
  end
end
