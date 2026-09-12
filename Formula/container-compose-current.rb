class ContainerComposeCurrent < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/current-52151f62ab9d10fc777ee1263ee12ec678da4410/container-compose-plugin-current-52151f62ab9d-arm64.tar.gz"
  version "current.1224.52151f62ab9d"
  sha256 "be3311f7589b31f337f2415ffe8959221cf3dd55946865f27d20fe53eb4f83be"
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
        container-compose-plugin-current-52151f62ab9d-arm64.tar.gz
    EOS
  end

  test do
    assert_match "0.14.3", shell_output("#{bin}/container-compose version --short")
    assert_path_exists libexec/"container-plugins/compose/config.toml"
    assert_predicate libexec/"container-plugins/compose/resources/compose-normalizer", :executable?
  end
end
