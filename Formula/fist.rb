class Fist < Formula
  desc "F:st: fast, extensible terminal file manager"
  homepage "https://github.com/Squirreljetpack/fist"
  version "0.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.5/fist-aarch64-apple-darwin.tar.xz"
      sha256 "f1c3681fb100ee9cd49043e697a3cc82eb687f5e6cdc3e48476aa44d51d0670c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.5/fist-x86_64-apple-darwin.tar.xz"
      sha256 "94cb0f1f46234c2e97a59ef2ecf615c253776541e461f7247cd513874fef8520"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.5/fist-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ece4d852a6a3b4e2ce60cb3a1090b0b5171b7bbb34b438ba77cd2225c9cb5462"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/fist/releases/download/v0.0.5/fist-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "efe3db76c3fb2b670d3d0516b6e1123db5679be3cb0993265fa1be47584edf43"
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
