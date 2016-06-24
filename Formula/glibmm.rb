class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "http://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.48/glibmm-2.48.1.tar.xz"
  sha256 "dc225f7d2f466479766332483ea78f82dc349d59399d30c00de50e5073157cdf"

  bottle do
    cellar :any
    sha256 "75e5051767721d67395041cb03cfbbc558419ff6cc53911c5ce14dc6e7ff9fa8" => :el_capitan
    sha256 "6a5667eb4d7653b6cb3bc7f03f45dfedf083ec129eefcb0aa8174fa87a4cfa44" => :yosemite
    sha256 "11a80950363e3b8f1561194ecd369948dcf983fba2894cf0e06266a5fde02562" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsigc++"
  depends_on "glib"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
