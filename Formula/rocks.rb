class Rocks < Formula
  desc "Command line tool for scraping Yahoo Finance stock information"
  homepage "https://github.com/NarodBocaj/rocks"
  url "https://github.com/NarodBocaj/rocks/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "fa47d86a879c933c8a5fa50c2f3a23fc5aaca13f6250653ceb73581d6d77ff9d"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
  
    # Install the CSV files to pkgshare
    pkgshare.install "filtered_data/equities.csv"
    pkgshare.install "filtered_data/etfs.csv"
  
    # Move the actual binary to libexec
    libexec.install "target/release/rocks"
  
    # Create a wrapper that sets the correct env var and runs the binary
    (bin/"rocks").write <<~EOS
      #!/bin/bash
      export ROCKS_DATA_DIR="#{pkgshare}"
      exec "#{libexec}/rocks" "$@"
    EOS
    chmod 0755, bin/"rocks"
  end
  

  test do
    system "#{bin}/rocks", "--version"
  end
end