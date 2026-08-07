class FeelingDynamic < Formula
  desc "Dynamic ONNX Runtime variant of feeling CLI (requires system libonnxruntime)"
  homepage "https://github.com/Squirreljetpack/feeling"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.4/feeling-dynamic-aarch64-apple-darwin.tar.xz"
      sha256 "ad7a17e62452ad60e7b0d20082cd2b4013cf3e1051d8d727df102a61abac5687"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.4/feeling-dynamic-x86_64-apple-darwin.tar.xz"
      sha256 "73e5629f7450c2884aa1b2fa3be77c4d9a49df5baa62ce6735c3f7423afa9f42"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Squirreljetpack/feeling/releases/download/v0.2.4/feeling-dynamic-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6811831bb45e2d2bf6570c9b5fa17a4fd8ace51b3fbe4f7dc2e73c3719690871"
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
