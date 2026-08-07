class Feeling < Formula
  desc "A CLI tool for tracking moods, journaling, habits, metrics, and for managing oneshot, recurring and scheduled tasks"
  homepage "https://github.com/Squirreljetpack/feeling"
  version "0.2.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.3/feeling-aarch64-apple-darwin.tar.xz"
    sha256 "b7512357bcd2a65387c8b201a2228d35f98023e37c6812ab08d8228c57731708"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.3/feeling-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "cacec26e5affc0a6447e68f1f38c41bebb2f7f92a2e099d8cc874d85170db23a"
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
    bin.install "feeling" if OS.mac? && Hardware::CPU.arm?
    bin.install "feeling" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
