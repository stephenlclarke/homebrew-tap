class ContainerComposeRelease < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/homebrew-release/container-compose-plugin-release-release-arm64.tar.gz"
  version "release-release-db75b0af6aec"
  sha256 "c0ffa3394b96c1abc38aac7d06ef449d397d9d8fc46c1acc89c0edcf78505a86"
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

      To make the Homebrew-installed container CLI discover it, link it into
      container-release's user plugin directory and restart the container-release service:
        mkdir -p "$(brew --prefix container-release)/libexec/container-plugins"
        ln -sfn "#{opt_libexec}/container-plugins/compose" "$(brew --prefix container-release)/libexec/container-plugins/compose"
        brew services restart container-release

      This formula installs the release release prebuilt release asset:
        container-compose-plugin-release-release-arm64.tar.gz
    EOS
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/container-compose version --short")
    assert_path_exists libexec/"container-plugins/compose/config.toml"
    assert_predicate libexec/"container-plugins/compose/resources/compose-normalizer", :executable?
  end
end
