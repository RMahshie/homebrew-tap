class Tokenburn < Formula
  desc "Track token usage and burn for Claude Code and Codex"
  homepage "https://github.com/RMahshie/tokenburn"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/RMahshie/tokenburn/releases/download/v1.0.0/tokenburn-aarch64-apple-darwin.tar.xz"
      sha256 "4468512ba726c17134c4c3d0b437e6a6f2fbf159c00afb195fb5ad715917b6e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RMahshie/tokenburn/releases/download/v1.0.0/tokenburn-x86_64-apple-darwin.tar.xz"
      sha256 "c61bb052f63cd298ef302e5bc88c44a439aba0d779044e942ea6f0e0ab5e3a40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/RMahshie/tokenburn/releases/download/v1.0.0/tokenburn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cd5502170469ac8a75348fe928dbee5589079633cd63977d59a17b4d03927986"
    end
    if Hardware::CPU.intel?
      url "https://github.com/RMahshie/tokenburn/releases/download/v1.0.0/tokenburn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a1cfc467b16766975cf2bc1101f0d2597502e01ad0f2bb494e0758fd5bf568c"
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
