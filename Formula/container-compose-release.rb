class ContainerComposeRelease < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/homebrew-release/container-compose-plugin-release-release-arm64.tar.gz"
  version "release-release-ac0fa5b44114"
  sha256 "fec9b1cb43d27665a01c2032cda6c5207fb482a77d8c1d7320a8657c6cff6e3e"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on "stephenlclarke/tap/container-release"
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
      container-release's user plugin directory and restart the container-release service:
        mkdir -p "$(brew --prefix container-release)/libexec/container-plugins"
        ln -sfn "#{opt_libexec}/container-plugins/compose" "$(brew --prefix container-release)/libexec/container-plugins/compose"
        brew services restart container-release

      This formula installs the latest release prebuilt release asset:
        container-compose-plugin-release-release-arm64.tar.gz
    EOS
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/container-compose version --short")
    assert_path_exists libexec/"container-plugins/compose/config.toml"
    assert_predicate libexec/"container-plugins/compose/resources/compose-normalizer", :executable?
  end
end
