class Matchmaker < Formula
  desc "Command-line interface for the matchmaker fuzzy finder"
  homepage "https://github.com/Squirreljetpack/matchmaker"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.6/matchmaker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "13c509ee9ea30dbafb3ba707aec996ea3695376cc1e4927b55009cfa8d7c712b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.6/matchmaker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4e389b7e7ee700eba94654ac01888fb982052109a6861a0af0fe172f1a25656d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.6/matchmaker-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6ec3d22f496b5829869e9658c65a6490763d786ff1f9b30d8e526018d755bf40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.6/matchmaker-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "62ab133f769b3f33e710a7140240090b1c50b6bc28895314833ac8dba649ed08"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "mm"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "mm"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "mm"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mm"
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
