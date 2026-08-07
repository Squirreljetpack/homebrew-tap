class FeelingDynamic < Formula
  desc "Dynamic ONNX Runtime variant of feeling CLI (requires system libonnxruntime)"
  homepage "https://github.com/Squirreljetpack/feeling"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.2/feeling-dynamic-aarch64-apple-darwin.tar.xz"
      sha256 "667b6442a1ae2a8a1019de93fa3ed1194c7ff665e685eb543bbb59768c26686c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.2/feeling-dynamic-x86_64-apple-darwin.tar.xz"
      sha256 "71be07c809b9bcf69d80267218c59896415102ca507274a2c595a7153a3c0766"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.2/feeling-dynamic-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "87b7bea68f0438007adae103f2a98dc5acafb9ad8593d3cc73c868034f892cdf"
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
    bin.install "feeling-dynamic" if OS.mac? && Hardware::CPU.arm?
    bin.install "feeling-dynamic" if OS.mac? && Hardware::CPU.intel?
    bin.install "feeling-dynamic" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
