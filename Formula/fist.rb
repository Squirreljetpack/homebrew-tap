class Fist < Formula
  desc "Fist: Interactive Search Tool"
  homepage "https://github.com/Squirreljetpack/fist"
  version "0.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.4/fist-aarch64-apple-darwin.tar.xz"
      sha256 "1cdca991f66d88b563f1ae05e89d6b3483022f3b536547b923eb4c8097f63b01"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.4/fist-x86_64-apple-darwin.tar.xz"
      sha256 "c1f40c4ce6cc1009ff7d5bc3f4cd579fd03bbae30c240e1117051fe7c6ae7e91"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.4/fist-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1b00ece7328734b2204c22bf4f0e6b487a3b670bdb6d991a791bee2001510a9d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.4/fist-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f245dcded51bf01c1d2929d901f5a473f7607f41c52e6fe647ecf39506ddf45"
    end
  end

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
      bin.install "fs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "fs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "fs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "fs"
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
