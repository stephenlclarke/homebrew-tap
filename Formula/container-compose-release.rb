class ContainerComposeRelease < Formula
  desc "Docker Compose style plugin for Apple's container CLI"
  homepage "https://github.com/stephenlclarke/container-compose"
  url "https://github.com/stephenlclarke/container-compose/releases/download/homebrew-release/container-compose-plugin-release-release-arm64.tar.gz"
  version "release-release-86b95bf54f45"
  sha256 "60c4b1034fa99c0b83f261e9506d3a9d605e3401d9d1cd5193e213a54d930fa3"
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
