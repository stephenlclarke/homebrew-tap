class ContainerComposeReleaseV030 < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/homebrew-release-v0.3.0/container-compose-plugin-release-v0.3.0-release-arm64.tar.gz"
  version "release-v0.3.0-release-12c6ed0b8a1e"
  sha256 "55085534e9e9524686e024da6263768a636534dd60dc514d7b0c98ac1d42d315"
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

  def caveats
    <<~EOS
      The plugin is installed under:
        #{opt_libexec}/container-plugins/compose

      The container-release formula owns the plugin registration link. Refresh it and
      restart stephenlclarke/tap/container-release after installing or upgrading this plugin:
        brew postinstall stephenlclarke/tap/container-release
        brew services restart stephenlclarke/tap/container-release

      This formula installs the release-v0.3.0 branch prebuilt package asset:
        container-compose-plugin-release-v0.3.0-release-arm64.tar.gz
    EOS
  end

  test do
    assert_match "0.3.0", shell_output("#{bin}/container-compose version --short")
    assert_path_exists libexec/"container-plugins/compose/config.toml"
    assert_predicate libexec/"container-plugins/compose/resources/compose-normalizer", :executable?
  end
end
