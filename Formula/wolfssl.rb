class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com/wolfSSL/Home.html"
  url "https://github.com/wolfSSL/wolfssl/archive/v3.9.0.tar.gz"
  sha256 "9d461209f663391d4c0349c23466556782c13964b9626fef694f2d420a176658"
  head "https://github.com/wolfSSL/wolfssl.git"

  bottle do
    cellar :any
    revision 1
    sha256 "95313d86eb3b52bd95b60e82330831dcf8e746487a6c5089cfeb4cc9e38e9999" => :el_capitan
    sha256 "12fbbfb36905d713f725da5c0fbd98fceac4c6deb92c537015eac0aa225ef722" => :yosemite
    sha256 "2464f16049276e889952be50add8b0b479c5eea8cb91f0181ae468451f47ddd9" => :mavericks
  end

  option "without-test", "Skip compile-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    # https://github.com/Homebrew/brew/pull/251
    ENV.delete("SDKROOT")

    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --disable-bump
      --disable-examples
      --disable-fortress
      --disable-md5
      --disable-sniffer
      --disable-webserver
      --enable-aesccm
      --enable-aesgcm
      --enable-alpn
      --enable-blake2
      --enable-camellia
      --enable-certgen
      --enable-certreq
      --enable-chacha
      --enable-crl
      --enable-crl-monitor
      --enable-dtls
      --enable-dh
      --enable-ecc
      --enable-eccencrypt
      --enable-ecc25519
      --enable-ed25519
      --enable-filesystem
      --enable-hc128
      --enable-hkdf
      --enable-inline
      --enable-ipv6
      --enable-jni
      --enable-keygen
      --enable-ocsp
      --enable-opensslextra
      --enable-poly1305
      --enable-psk
      --enable-rabbit
      --enable-ripemd
      --enable-savesession
      --enable-savecert
      --enable-sessioncerts
      --enable-sha512
      --enable-sni
      --enable-supportedcurves
    ]

    if MacOS.prefer_64_bit?
      args << "--enable-fastmath" << "--enable-fasthugemath"
    else
      args << "--disable-fastmath" << "--disable-fasthugemath"
    end

    args << "--enable-aesni" if Hardware::CPU.aes? && !build.bottle?

    # Extra flag is stated as a needed for the Mac platform.
    # https://wolfssl.com/wolfSSL/Docs-wolfssl-manual-2-building-wolfssl.html
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags "-mdynamic-no-pic" if MacOS.prefer_64_bit?

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system bin/"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end
