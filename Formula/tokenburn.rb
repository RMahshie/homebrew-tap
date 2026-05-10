class Tokenburn < Formula
  desc "Track token usage and burn for Claude Code and Codex"
  homepage "https://github.com/RMahshie/tokenburn"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RMahshie/tokenburn/releases/download/v1.0.1/tokenburn-aarch64-apple-darwin.tar.xz"
      sha256 "4014f382f78da4048b5ff29760fa7d011632635473bef2b74e7db2172297a4d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RMahshie/tokenburn/releases/download/v1.0.1/tokenburn-x86_64-apple-darwin.tar.xz"
      sha256 "fed7bff9d05f34bb28be8ef35011d5b8502d0b821ae762a6fd7ba83dd6209b0e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RMahshie/tokenburn/releases/download/v1.0.1/tokenburn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e0bdaee758d1797e85a384c416ca830ce1e2111776771263fb107f52e37ef98d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RMahshie/tokenburn/releases/download/v1.0.1/tokenburn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f5cb686bc6e3b03422421a6b378601730154a4e95482acfc5ccfae0e5e5d60b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tokenburn" if OS.mac? && Hardware::CPU.arm?
    bin.install "tokenburn" if OS.mac? && Hardware::CPU.intel?
    bin.install "tokenburn" if OS.linux? && Hardware::CPU.arm?
    bin.install "tokenburn" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
