class Matchmaker < Formula
  desc "Command-line interface for the matchmaker fuzzy finder"
  homepage "https://github.com/Squirreljetpack/matchmaker"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.1.1/matchmaker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b383af56254a53febcf63c7aec5f6473cf3d03c53e75045fff82bd6ef948bd7c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.1.1/matchmaker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "474ee217626608c2a35fd1dddea0d177f83718cfb93aa12a32ef52b4465eb56c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.1.1/matchmaker-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d3fc13d577d178ba4a63f041312b455d6c28171e915b5cf84a9552618e4f40a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.1.1/matchmaker-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23c2101452799ac1e42223858a7ab3c8373925bbb12b56671d5fa55860043002"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "aarch64-unknown-linux-gnu":         {},
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
    bin.install "mm" if OS.mac? && Hardware::CPU.arm?
    bin.install "mm" if OS.mac? && Hardware::CPU.intel?
    bin.install "mm" if OS.linux? && Hardware::CPU.arm?
    bin.install "mm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
