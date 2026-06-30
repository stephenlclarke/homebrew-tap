class Sqlterm < Formula
  desc "Interactive SQL terminal using local ODBC connection profiles"
  homepage "https://github.com/stephenlclarke/sqlterm"
  head "https://github.com/stephenlclarke/sqlterm.git", branch: "main"

  depends_on "go" => :build
  depends_on "unixodbc"

  def install
    unixodbc = Formula["unixodbc"]
    ENV.append "CGO_CFLAGS", "-I#{unixodbc.opt_include}"
    ENV.append "CGO_LDFLAGS", "-L#{unixodbc.opt_lib}"
    system "go", "build", "-trimpath", "-o", bin/"sqlterm", "./cmd"
  end

  def caveats
    <<~EOS
      SQLTerm reads database credentials from:
        ~/.config/sqlterm/databases.json

      Configure ODBC DSNs with unixODBC, or provide a connection_string,
      driver plus hostname, or dsn entry in that file.
    EOS
  end

  test do
    assert_match "could not read databases file", shell_output("#{bin}/sqlterm 2>&1", 1)
  end
end
