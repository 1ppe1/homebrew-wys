class Wys < Formula
  desc "Typed, compiled language for LLM agents with runtime-enforced permissions"
  homepage "https://github.com/1ppe1/wys"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/1ppe1/wys/releases/download/v0.1.0/wys-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "05a2a65a21d11dfca278929912cbea140d8faa5a614a245263c7a81bc3aa0dc7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/1ppe1/wys/releases/download/v0.1.0/wys-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c6e4b78a5f164e2cd060e45253dae0ff93e229756c4df725345e47333444e4c0"
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
