class Feeling < Formula
  desc "A CLI tool for tracking moods, journaling, habits, metrics, and for managing oneshot, recurring and scheduled tasks"
  homepage "https://github.com/Squirreljetpack/feeling"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/feeling/releases/download/v0.1.0/feeling-aarch64-apple-darwin.tar.xz"
      sha256 "ff77b53445cf08248821a923527b8383cfcfd86f22c8bee59d1897af4127817f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/feeling/releases/download/v0.1.0/feeling-x86_64-apple-darwin.tar.xz"
      sha256 "36eecb1425d95bb9d2df1b68fe9e55eb4722cc12d5a06f32d51db031223a16fa"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/feeling/releases/download/v0.1.0/feeling-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "67c6dd43c30c3ec484f2de93252a9df4c31b5ec517ff9d8d07234d48505aeccf"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "feeling" if OS.mac? && Hardware::CPU.intel?
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
