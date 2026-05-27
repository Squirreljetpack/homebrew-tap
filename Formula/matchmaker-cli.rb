class MatchmakerCli < Formula
  desc "Command-line interface for the matchmaker fuzzy finder"
  homepage "https://github.com/Squirreljetpack/matchmaker"
  version "0.0.36"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.36/matchmaker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "46c99d84015624f2ab4f00916242569626f1bc894893c550dc21638326eb2300"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.36/matchmaker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7d3fdd7834c3b55468ac795abc2b2546c4f41205ad0620fc9c38c68eb41c22cb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.36/matchmaker-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9bc957def03f5c3c1b1c10efffa2fec9de90586169dab4188c5bfd79b7b4e405"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.36/matchmaker-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d228defd183483f099ea39d27828faa409dba1cb599d7195fb3e2916dd6afc10"
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
