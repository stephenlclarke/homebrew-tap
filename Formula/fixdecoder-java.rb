class FixdecoderJava < Formula
  desc "Java implementation of the FIX log prettifier and dictionary explorer"
  homepage "https://github.com/stephenlclarke/fixdecoder_java"
  license "AGPL-3.0-only"
  head "https://github.com/stephenlclarke/fixdecoder_java.git", branch: "main"

  depends_on "maven" => :build
  depends_on "openjdk@21"

  def install
    java_home = Formula["openjdk@21"].opt_prefix/"libexec/openjdk.jdk/Contents/Home"
    ENV["JAVA_HOME"] = java_home
    ENV.prepend_path "PATH", java_home/"bin"

    system "mvn", "-q", "-DskipTests", "package"

    jar = Dir["target/fixdecoder-java-*.jar"].reject { |path| File.basename(path).start_with?("original-") }.first
    libexec.install jar => "fixdecoder-java.jar"

    (bin/"fixdecoder-java").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk@21"].opt_bin}/java" -jar "#{opt_libexec}/fixdecoder-java.jar" "$@"
    EOS
  end

  test do
    assert_match "FIX protocol utility", shell_output("#{bin}/fixdecoder-java --help")
  end
end
