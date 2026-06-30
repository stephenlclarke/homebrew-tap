class Sqlterm < Formula
  desc "Terminal helper for launching MySQL connections from local config"
  homepage "https://github.com/stephenlclarke/sqlterm"
  head "https://github.com/stephenlclarke/sqlterm.git", branch: "main"

  depends_on "go" => :build
  depends_on "mysql-client"

  def install
    system "go", "build", "-trimpath", "-o", "sqlterm", "./cmd"
    libexec.install "sqlterm"

    (bin/"sqlterm").write_env_script libexec/"sqlterm",
      PATH: "#{formula_opt_bin("mysql-client")}:$PATH"
  end

  def caveats
    <<~EOS
      SQLTerm reads database credentials from:
        ~/.config/sqlterm/databases.json

      This formula wraps sqlterm so Homebrew's mysql-client is available
      on PATH when sqlterm launches the mysql client.
    EOS
  end

  test do
    assert_match "could not read databases file", shell_output("#{bin}/sqlterm 2>&1", 1)
  end
end
