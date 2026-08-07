class Feeling < Formula
  desc "A CLI tool for tracking moods, journaling, habits, metrics, and for managing oneshot, recurring and scheduled tasks"
  homepage "https://github.com/Squirreljetpack/feeling"
  version "0.2.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.2/feeling-aarch64-apple-darwin.tar.xz"
    sha256 "09fa99c110b73ec1459dbeedba43b10eae82795969d1b6e603bd91defb6c7575"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.2/feeling-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "896c9962fe6012ee9792010d8d6082fc1cdd823ae854e003adfce1e4226cb586"
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
