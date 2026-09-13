class ContainerComposeCurrent < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/current-c44aec0c8addc5dfb5317e738aceb8a53dbffe2f/container-compose-plugin-current-c44aec0c8add-arm64.tar.gz"
  version "current.1232.c44aec0c8add"
  sha256 "4282c12a994044677f7c53a7f5cadd5f4b906ab638ed2d03a32b66c7ea218dfe"
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
        container-compose-plugin-current-c44aec0c8add-arm64.tar.gz
    EOS
  end

  test do
    assert_match "0.15.0", shell_output("#{bin}/container-compose version --short")
    assert_path_exists libexec/"container-plugins/compose/config.toml"
    assert_predicate libexec/"container-plugins/compose/resources/compose-normalizer", :executable?
  end
end
