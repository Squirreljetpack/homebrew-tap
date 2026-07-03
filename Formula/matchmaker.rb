class Matchmaker < Formula
  desc "Command-line interface for the matchmaker fuzzy finder"
  homepage "https://github.com/Squirreljetpack/matchmaker"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.1.3/matchmaker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "217d947584ba536adc1ea84a6b08f56b7de6609c020eb654f722d732b3594a1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.1.3/matchmaker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7c5670335740c268823eecad6bb4533e88e26820cb35f605a9222346b7905949"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.1.3/matchmaker-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e655c707ca086dc25923509717c871f0cb703a47ca041420ee86ee9aad949a53"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.1.3/matchmaker-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "111968eccfdb36decd1188350ac71ca7d816d267f970f34b7fb53d5368372c6c"
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
