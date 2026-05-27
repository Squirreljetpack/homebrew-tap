class Matchmaker < Formula
  desc "Command-line interface for the matchmaker fuzzy finder"
  homepage "https://github.com/Squirreljetpack/matchmaker"
  version "0.0.38"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.38/matchmaker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "787774f6f024d22ba991999b8fa582026f9f9873593879f0e1446f6966aca845"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.38/matchmaker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ff5af81edaf6b0d0c0e9d63a791952a1c2ab5b89b306592e426834dfadeb722e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.38/matchmaker-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1a2105cebe6cc1ddf6f1c0edf00b077103f00b3660a0ac79fb924b0149625a2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.38/matchmaker-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c119c38c8269e46e8a4ee1c0c1864770149a95d6ccbf152f00b8019a3648905a"
    end
  end
  license "MIT"

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
    bin.install "mm" if OS.mac? && Hardware::CPU.arm?
    bin.install "mm" if OS.mac? && Hardware::CPU.intel?
    bin.install "mm" if OS.linux? && Hardware::CPU.arm?
    bin.install "mm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
