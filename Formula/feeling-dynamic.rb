class FeelingDynamic < Formula
  desc "Dynamic ONNX Runtime variant of feeling CLI (requires system libonnxruntime)"
  homepage "https://github.com/Squirreljetpack/feeling"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.3/feeling-dynamic-aarch64-apple-darwin.tar.xz"
      sha256 "7b94dee14540e280e42470eb9336cec126b37bbd52bc119499d476a47bc5ebf3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.3/feeling-dynamic-x86_64-apple-darwin.tar.xz"
      sha256 "4b85454564ad28e40e2399781cdf914a32c5d3e1840dfcf74dca839c8f8e9af2"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.3/feeling-dynamic-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a53e17d057b95ca2554c277b9a79ceed97440648a76fbbb4d9e16290e8860ad5"
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
