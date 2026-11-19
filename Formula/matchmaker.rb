class Matchmaker < Formula
  desc "Command-line interface for the matchmaker fuzzy finder"
  homepage "https://github.com/Squirreljetpack/matchmaker"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.8/matchmaker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0013f989351d90196816c8f78bdb28a2892d1b672834a3e94e7e396cd28c7c05"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.8/matchmaker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "15b827d6fdd1350e30533de45c3003cdf1b53e533655d2004984f268dcf2ea46"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.8/matchmaker-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8ade9025f881ef5f26d658438391aa83495b58fa8c565aff0320d702ab5adbb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.8/matchmaker-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fd5695775be77eb4ddcb9c51be5f47e9fc87219f60e282b374c16e6cad4a5d32"
    end
  end
  license "AGPL-3.0-only"

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "mm"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "mm"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "mm"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mm"
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
