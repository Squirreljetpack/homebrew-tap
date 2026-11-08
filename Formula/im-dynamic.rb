class ImDynamic < Formula
  desc "Dynamic ONNX Runtime variant of im CLI (requires system libonnxruntime)"
  homepage "https://github.com/Squirreljetpack/im"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/im/releases/download/v0.3.1/im-dynamic-aarch64-apple-darwin.tar.xz"
      sha256 "df1806bf886a32924f12e876c2761997cc3562408db5d53a0825a60965e7c97f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/im/releases/download/v0.3.1/im-dynamic-x86_64-apple-darwin.tar.xz"
      sha256 "499f6adf0c16f659798584d2cc1273ac446abeb1784f05c633b40fc36a90ad0b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/im/releases/download/v0.3.1/im-dynamic-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3f50ed6288286802263fcb1abf5935a242658b9dedc06da0d14c1a8a2b9fb6a7"
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
