class Rocks < Formula
    desc "Command line tool for scraping Yahoo Finance stock information"
    homepage "https://github.com/NarodBocaj/rocks"
    url "https://github.com/NarodBocaj/rocks/archive/refs/tags/v0.1.1.tar.gz"
    sha256 "fa47d86a879c933c8a5fa50c2f3a23fc5aaca13f6250653ceb73581d6d77ff9d"
    license "MIT"

    depends_on "rust" => :build

    def install
      system "cargo", "install", "--path", "."
      
      # Install the CSV files
      pkgshare.install "filtered_data/equities.csv"
      pkgshare.install "filtered_data/etfs.csv"
      
      # Create a wrapper script that sets the correct path for the CSV files
      (bin/"rocks").write <<~EOS
        #!/bin/bash
        exec "#{bin}/rocks" "$@"
      EOS
    end

    test do
      system "#{bin}/rocks", "--version"
    end
  end