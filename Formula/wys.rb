class Wys < Formula
  desc "Typed, compiled language for LLM agents with runtime-enforced permissions"
  homepage "https://github.com/1ppe1/wys"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/1ppe1/wys/releases/download/v0.1.1/wys-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "6462cde4fe0febba95bc42e266b82f95a149d2efa55bbae56dc49d44414bb362"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/1ppe1/wys/releases/download/v0.1.1/wys-0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41bd6d270dd2158b22ad491a2947fde04940c05492900caf08f22592ff9fae08"
    end
  end

  def install
    # The compiler looks for its runtime libraries in <exe>/../lib (ADR-0030).
    libexec.install "bin", "lib"
    bin.install_symlink libexec/"bin/wys"
    doc.install Dir["README*", "CHANGELOG.md"]
  end

  def caveats
    <<~EOS
      wys links programs with clang. On macOS it comes with the Xcode Command Line Tools:
        xcode-select --install
    EOS
  end

  test do
    (testpath/"hello.wys").write <<~WYS
      def main() -> None:
          print("hello from wys")
    WYS
    assert_equal "hello from wys\n", shell_output("#{bin}/wys run #{testpath}/hello.wys")
    assert_match version.to_s, shell_output("#{bin}/wys --version")
  end
end
