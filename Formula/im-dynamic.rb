class ImDynamic < Formula
  desc "Dynamic ONNX Runtime variant of im CLI (requires system libonnxruntime)"
  homepage "https://github.com/Squirreljetpack/im"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/im/releases/download/v0.2.5/im-dynamic-aarch64-apple-darwin.tar.xz"
      sha256 "af0e2a1b0a97f8b9f00c354ee7f946a36859628f89917c82a4c3873d86ce7066"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/im/releases/download/v0.2.5/im-dynamic-x86_64-apple-darwin.tar.xz"
      sha256 "9768c9eb0efadce37ca83253d39e468544dafc73bdfc01966ea1064996c22287"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/im/releases/download/v0.2.5/im-dynamic-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "22c866bef85cda1cf1e2be5bcb50eaebb0c8c751bc55fdd30d792b99e08ee33e"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "im-dynamic"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "im-dynamic"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "im-dynamic"
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
