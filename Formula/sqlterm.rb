class Sqlterm < Formula
  desc "Interactive SQL terminal using local ODBC connection profiles"
  homepage "https://github.com/stephenlclarke/sqlterm"
  head "https://github.com/stephenlclarke/sqlterm.git", branch: "main"

  depends_on "go" => :build
  depends_on "unixodbc"

  def install
    ENV.append "CGO_CFLAGS", "-I#{formula_opt_include("unixodbc")}"
    ENV.append "CGO_LDFLAGS", "-L#{formula_opt_lib("unixodbc")}"
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
