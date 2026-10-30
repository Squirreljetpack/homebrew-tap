class ImDynamic < Formula
  desc "Dynamic ONNX Runtime variant of im CLI (requires system libonnxruntime)"
  homepage "https://github.com/Squirreljetpack/im"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/im/releases/download/v0.2.7/im-dynamic-aarch64-apple-darwin.tar.xz"
      sha256 "8309446713a09311043b1900e9dc132b6021272fa4b43cc731402efe71f27048"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/im/releases/download/v0.2.7/im-dynamic-x86_64-apple-darwin.tar.xz"
      sha256 "e5e912578515e497631897ed2bc677429b74fd1ee4f492e7cfc1581091c92432"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/im/releases/download/v0.2.7/im-dynamic-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ab6f273c693c87465bc38ae8432897e24840d80498ef752ac014b05dd332bdd9"
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
