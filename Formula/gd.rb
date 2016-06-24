class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  revision 1

  stable do
    url "https://github.com/libgd/libgd/archive/gd-2.2.1.tar.gz"
    sha256 "06b0f2ef45fbdde7b05816a8a988868b11ac348f77ffa15a958128a8106b1e08"

    # Prevents need for a dependency on gnu-sed; fixes
    #  sed: 1: "2i/* Generated from con ...": command i expects \ followed by text
    # Requires the source archive tarball to apply cleanly; fix taken from HEAD,
    # so most likely the release tarball can be restored upon the next release
    patch do
      url "https://github.com/libgd/libgd/commit/0bc8586e.patch"
      sha256 "fc7e372c873afc6f750256f49cd7f3540b0e424e10a1a25fa708d2ebd2d3c9ca"
    end

    # https://github.com/libgd/libgd/issues/214
    patch do
      url "https://github.com/libgd/libgd/commit/502e4cd8.patch"
      sha256 "34fecd59b7f9646492647503375aaa34896bcc5a6eca1408c59a4b17e84896da"
    end

    # These are only needed for the 2.2.1 release. Remove on next
    # stable release & reset bootstrap step to head-only in install.
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
    depends_on "gettext" => :build
  end

  bottle do
    cellar :any
    sha256 "f773ad16deb79598d1d176f76dcfb47e9d3c09a0a46f12de9bf32a109f7a9782" => :el_capitan
    sha256 "77d0417f21909badb6643ed5ae435532c35c2a9cdbf0db9db16739765da7d004" => :yosemite
    sha256 "ef94bf115b380c741c3ec1a29e25ff6e69b68870adb847c3a170de43e5f96164" => :mavericks
  end

  head do
    url "https://github.com/libgd/libgd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "fontconfig" => :recommended
  depends_on "freetype" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp" => :recommended

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --without-xpm
    ]

    if build.with? "libpng"
      args << "--with-png=#{Formula["libpng"].opt_prefix}"
    else
      args << "--without-png"
    end

    if build.with? "fontconfig"
      args << "--with-fontconfig=#{Formula["fontconfig"].opt_prefix}"
    else
      args << "--without-fontconfig"
    end

    if build.with? "freetype"
      args << "--with-freetype=#{Formula["freetype"].opt_prefix}"
    else
      args << "--without-freetype"
    end

    if build.with? "jpeg"
      args << "--with-jpeg=#{Formula["jpeg"].opt_prefix}"
    else
      args << "--without-jpeg"
    end

    if build.with? "libtiff"
      args << "--with-tiff=#{Formula["libtiff"].opt_prefix}"
    else
      args << "--without-tiff"
    end

    if build.with? "webp"
      args << "--with-webp=#{Formula["webp"].opt_prefix}"
    else
      args << "--without-webp"
    end

    system "./bootstrap.sh"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pngtogd", test_fixtures("test.png"), "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end
