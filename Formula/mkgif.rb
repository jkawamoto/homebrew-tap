class Mkgif < Formula
  desc "Create an animation GIF from the given image files"
  homepage "https://github.com/jkawamoto/mkgif"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jkawamoto/mkgif/releases/download/v0.1.1/mkgif-aarch64-apple-darwin.tar.xz"
      sha256 "017bcc2149b00fd9a0d218a58f2f83ee94843a2c742e5f4bd1c66bf2e5af1883"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jkawamoto/mkgif/releases/download/v0.1.1/mkgif-x86_64-apple-darwin.tar.xz"
      sha256 "c6ebc28284965303e172a024c96133d98cfa324b37e96b613499628f1325b1e1"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/jkawamoto/mkgif/releases/download/v0.1.1/mkgif-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e1131b75f0b3c3d75d6a18b91a1113907cb0234856f1bc48eaa84556f691280b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "mkgif"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "mkgif"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mkgif"
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
