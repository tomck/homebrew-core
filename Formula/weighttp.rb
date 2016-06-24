class Weighttp < Formula
  desc "Webserver benchmarking tool that supports multithreading"
  homepage "https://redmine.lighttpd.net/projects/weighttp/wiki"
  url "https://github.com/lighttpd/weighttp/archive/weighttp-0.4.tar.gz"
  sha256 "b4954f2a1eca118260ffd503a8e3504dd32942e2e61d0fa18ccb6b8166594447"
  head "https://git.lighttpd.net/weighttp.git"

  bottle do
    cellar :any
    sha256 "e96be0135f552ddde0547ca914c2bc6635dcc59ce4bdeb803ab9412100d8d15b" => :el_capitan
    sha256 "e83c9f99b524b57ba31571dc673ab6d2d2a5e38a5374ce45130f11a51c063662" => :yosemite
    sha256 "914e5fbf3f6c4fd42c532fa32a741c0558b7b16a71d773722c92c64f0b42a2f3" => :mavericks
  end

  depends_on "libev"

  def install
    system "./waf", "configure"
    system "./waf", "build"
    bin.install "build/default/weighttp"
  end

  test do
    # Stick with HTTP to avoid 'error: no ssl support yet'
    system "#{bin}/weighttp", "-n", "1", "http://redmine.lighttpd.net/projects/weighttp/wiki"
  end
end
