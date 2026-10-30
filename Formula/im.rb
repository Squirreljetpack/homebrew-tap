class Im < Formula
  desc "A CLI tool for tracking moods, journaling, habits, metrics, and for managing oneshot, recurring and scheduled tasks"
  homepage "https://github.com/Squirreljetpack/im"
  version "0.2.9"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Squirreljetpack/im/releases/download/v0.2.9/im-aarch64-apple-darwin.tar.xz"
    sha256 "174ff9bc70efc591985c4898c2159959476b599598173453d127969afdebf6e8"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/im/releases/download/v0.2.9/im-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2b2d1ff099cad9bf7a1ec9f3c179a83fea4a3fc0e4f46e2efe98435a6d5e044a"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "im"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "im"
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
