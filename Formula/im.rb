class Im < Formula
  desc "A CLI tool for tracking moods, journaling, habits, metrics, and for managing oneshot, recurring and scheduled tasks"
  homepage "https://github.com/Squirreljetpack/im"
  version "0.2.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Squirreljetpack/im/releases/download/v0.2.5/im-aarch64-apple-darwin.tar.xz"
    sha256 "b72c01e77a608e3aa1d7d01ee8195f330ba0ed2d135b3cee8c55df3c16cf1000"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/im/releases/download/v0.2.5/im-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f81ab958e4f8c0a841ec2ab2d42387bc4d200516e676d87502ae21913c1c0ec2"
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
