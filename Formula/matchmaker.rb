class Matchmaker < Formula
  desc "Command-line interface for the matchmaker fuzzy finder"
  homepage "https://github.com/Squirreljetpack/matchmaker"
  version "0.0.37"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.37/matchmaker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f5e253364648e8e59cf352c4bdd3ee72643b1a777fc04312e146ffd57e82673a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.37/matchmaker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2ea0ec722114a3870f049cad4a33d8a2caea68d521fb4775662429368e05b758"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.37/matchmaker-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7a78468ded5a8fa97dab28c73700086e66cae723aa4cb0927aaebfa2b92c1e24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/0.0.37/matchmaker-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e36572ad920279eaff14e0685c80552a5c1612f01c904a83606b7f3cc74fe9fe"
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
