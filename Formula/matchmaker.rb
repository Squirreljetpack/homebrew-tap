class Matchmaker < Formula
  desc "Command-line interface for the matchmaker fuzzy finder"
  homepage "https://github.com/Squirreljetpack/matchmaker"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.7/matchmaker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6306daa6ef3d4cf3220002d800ba0f5f16340f5d2eabce857d3501978e50ecd1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.7/matchmaker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fa8b92cfc0a0dead8a68399d7ef1b10e8e8ef4ee31757ab832cf455fd1fd7f71"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.7/matchmaker-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4c7dc483946d2b35c0bbe8aca8e637af552d1f00764c16197e7380c74fcd458c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.1.7/matchmaker-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c0036d9e3ca8d1de40b8a67efedc80f031170c005e81474b228c39eb0f971114"
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
