class ContainerCompose < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/homebrew-main/container-compose-plugin-main-release-arm64.tar.gz"
  version "main-release-ac0fa5b44114"
  sha256 "3bbe6e6a8680a3e8dc851ebacfc0761c5f330e92023e33d42c0cfd7e0296c2a8"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on "container"
  depends_on macos: :sequoia

  def install
    plugin = libexec/"container-plugins/compose"
    plugin.install Dir["compose/*"]

    bin.install_symlink plugin/"bin/compose" => "container-compose"
  end

  def caveats
    <<~EOS
      The plugin is installed under:
        #{opt_libexec}/container-plugins/compose

      To make the Homebrew-installed container CLI discover it, link it into
      container's user plugin directory and restart the container service:
        mkdir -p "$(brew --prefix container)/libexec/container-plugins"
        ln -sfn "#{opt_libexec}/container-plugins/compose" "$(brew --prefix container)/libexec/container-plugins/compose"
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
