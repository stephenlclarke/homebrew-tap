class ContainerCompose < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/homebrew-main/container-compose-plugin-main-release-arm64.tar.gz"
  version "main-release-8b07f6082dd4"
  sha256 "d049c3c11f02709234219aedad080cfa8b3c16a88d4fd3ed1e0fd3f5f05939a1"
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

  def caveats
    <<~EOS
      The plugin is installed under:
        #{opt_libexec}/container-plugins/compose

      To make the Homebrew-installed container CLI discover it, link it into
      container's user plugin directory and restart the container service:
        mkdir -p "$(brew --prefix container)/libexec/libexec/container-plugins"
        ln -sfn "#{opt_libexec}/container-plugins/compose" "$(brew --prefix container)/libexec/libexec/container-plugins/compose"
        brew services restart container

      This formula installs the main release prebuilt release asset:
        container-compose-plugin-main-release-arm64.tar.gz
    EOS
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/container-compose version --short")
    assert_path_exists libexec/"container-plugins/compose/config.toml"
    assert_predicate libexec/"container-plugins/compose/resources/compose-normalizer", :executable?
  end
end
