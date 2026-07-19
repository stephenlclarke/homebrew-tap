class ContainerComposeCurrent < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/current/container-compose-plugin-current-213494dc7cf2-arm64.tar.gz"
  version "current.213494dc7cf2"
  sha256 "e0cd8f7a826925b89939ecca28d61053bc1fb6eb1c508afc311900df942ad414"
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
        container-compose-plugin-current-213494dc7cf2-arm64.tar.gz
    EOS
  end

  test do
    assert_match "0.6.70", shell_output("#{bin}/container-compose version --short")
    assert_path_exists libexec/"container-plugins/compose/config.toml"
    assert_predicate libexec/"container-plugins/compose/resources/compose-normalizer", :executable?
  end
end
