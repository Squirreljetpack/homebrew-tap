class Matchmaker < Formula
  desc "Command-line interface for the matchmaker fuzzy finder"
  homepage "https://github.com/Squirreljetpack/matchmaker"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.2.0/matchmaker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e1fc0dce352ab84a1a04cc5117753f4a234b5c51c20407d89fe6891894a2ae1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.2.0/matchmaker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a166346016801ef26c31077538fcbf3e963fbaefeb9bfc1f3fb35710c83f02cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.2.0/matchmaker-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "24fe7e64482daab18d091dcec9de767143a7fc490ef18875490b8492aff93fe8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Squirreljetpack/matchmaker/releases/download/v0.2.0/matchmaker-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bcac3710ffe881e56eca0725710313b193347143769dd9148dccce53e08b60be"
    end
  end
  license "AGPL-3.0-only"

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
