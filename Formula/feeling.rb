class Feeling < Formula
  desc "A CLI tool for tracking moods, journaling, habits, metrics, and for managing oneshot, recurring and scheduled tasks"
  homepage "https://github.com/Squirreljetpack/feeling"
  version "0.2.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.4/feeling-aarch64-apple-darwin.tar.xz"
    sha256 "48588391b953559d68b20ea0caeb33f51471618b25badb2195566767665e602d"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.4/feeling-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "972f573655b20edd35c6d9f89b12cdfdc5a45106f7de3621a8489f9d280a0fab"
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
      bin.install "feeling"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "feeling"
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
