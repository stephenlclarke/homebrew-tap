class Devcontainer < Formula
  desc "VS Code Dev Containers compatibility for Apple container"
  homepage "https://github.com/stephenlclarke/devcontainer"
  url "https://github.com/stephenlclarke/devcontainer/releases/download/1.0.0/devcontainer-release-arm64.tar.gz"
  sha256 "a6dd26b883de6056b12cc65e87ad93ebc1484d6f5cbbfab1dba4aa6e87ea3fdf"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on "docker"
  depends_on "docker-compose"
  depends_on macos: :tahoe

  def install
    bin.install "bin/devcontainer"
    bin.install "bin/devcontainer-engine"
    bin.install "bin/devcontainer-compose"
    libexec.install "libexec/container"
    pkgshare.install "share/devcontainer"
  end

  service do
    run [opt_bin/"devcontainer-engine"]
    keep_alive true
    process_type :interactive
    log_path var/"log/devcontainer.log"
    error_log_path var/"log/devcontainer-error.log"
  end

  def caveats
    <<~EOS
      Install either the stock Apple container package or a compatible
      container distribution before starting the service.

      Start Apple's stock runtime:
        /usr/local/bin/container system start

      When macOS requests Local Network access for the selected runtime's
      container-runtime-linux helper, choose Allow. Stock and custom runtime
      helpers may appear as separate permission entries.

      Start the compatibility engine:
        brew services start #{name}

      Use it without changing your default Docker context:
        eval "$(devcontainer context)"

      Configure VS Code's Dev Containers extension to use:
        #{opt_bin}/devcontainer-compose

      Register the optional Apple container CLI plug-in explicitly:
        devcontainer plugin register
    EOS
  end

  test do
    assert_match "1.0.0", shell_output("#{bin}/devcontainer version --short")
    assert_match "DOCKER_HOST", shell_output("#{bin}/devcontainer context")
    assert_path_exists libexec/"container/plugins/devcontainer/config.toml"
    assert_predicate libexec/"container/plugins/devcontainer/bin/devcontainer", :executable?
  end
end
