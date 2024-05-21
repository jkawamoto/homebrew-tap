class Vsop < Formula
  desc "Command line translation tool using CTranslate2"
  homepage "https://github.com/jkawamoto/vsop"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jkawamoto/vsop/releases/download/v0.1.0/vsop-aarch64-apple-darwin.tar.xz"
      sha256 "72744fa6fb374f4907296edb0801cd29ab4ce6cac3948ec37d652ef18f780f36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jkawamoto/vsop/releases/download/v0.1.0/vsop-x86_64-apple-darwin.tar.xz"
      sha256 "4354b023eb5c358ceb3f7fd5f06a7a10d4b2697e9d284d0fccde19b42919dbb9"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/jkawamoto/vsop/releases/download/v0.1.0/vsop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9cf6e5f97c774fea7419990c29ecd68c4a1c834a429420b40af43c6d972ea263"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vsop", "vsops"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "vsop", "vsops"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vsop", "vsops"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
