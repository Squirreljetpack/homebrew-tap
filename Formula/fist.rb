class Fist < Formula
  desc "F:st: fast, extensible terminal file manager"
  homepage "https://github.com/Squirreljetpack/fist"
  version "0.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.6/fist-aarch64-apple-darwin.tar.xz"
      sha256 "8794c414b7971e70564d54afc605bcbdef8ca13d19cfd84296775ca5007e9214"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.6/fist-x86_64-apple-darwin.tar.xz"
      sha256 "c5fb2b2eca7190d0f8180a3acc9467883102d6af65cbabeb3acf1b4187260f93"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.6/fist-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a36e4fde331ac1449c6e289646953123ec7142fb68f07a4212a440c377987d4a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.6/fist-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4f90522b0f15f7e42bb3d5630ffaf75f5ea1cb52d3df806706803cdc87303065"
    end
  end
  license "AGPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-pc-windows-gnu":             {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
