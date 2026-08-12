class Matchmaker < Formula
  desc "Command-line interface for the matchmaker fuzzy finder"
  homepage "https://github.com/Squirreljetpack/matchmaker"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.4/matchmaker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "080b60bba9df7261ae5703596e138fcefaa94c306bb141426b3505b539e18327"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.4/matchmaker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2d15d39e2eb2fb5f2d713b0e4f5a630a9e825f14d079511dd9fc1dfe3a67d3e9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.4/matchmaker-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "afdc34fb9d378107c639d31348b9938e7d6225d6ad5d0f8fcef5031956263c23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.4/matchmaker-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d26ca4d868df8c70f4a5503caef3d053f2b76a3e2007a9b3c4732fb490a0949"
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
