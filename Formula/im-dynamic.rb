class ImDynamic < Formula
  desc "Dynamic ONNX Runtime variant of im CLI (requires system libonnxruntime)"
  homepage "https://github.com/Squirreljetpack/im"
  version "0.2.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/im/releases/download/v0.2.10/im-dynamic-aarch64-apple-darwin.tar.xz"
      sha256 "e92ecb92a8799eeebf49877a3d3b42aad9638b590ebb3f5ba4bc90b971d05cc7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/im/releases/download/v0.2.10/im-dynamic-x86_64-apple-darwin.tar.xz"
      sha256 "9f836201b3ea33090eec3bb4a07d9fdf5d84002343a16ce2d569fdf1c0429da5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/im/releases/download/v0.2.10/im-dynamic-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f70dc4b88a93ac5a2a947fb42da6571d3eab5abf5a4b34007ce293fc81e51813"
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
