class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R32.tar.gz"
  sha256 "e9560f64ba298c2ef9e6e3d88f63ea0ab88e14bbd0e9feee9c621b9224e408c8"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "4a8fa4f491cdd0beabdc0837a665cf51421cf4ec203771fe8c7038143c6388da" => :el_capitan
    sha256 "d5030759c34088ac4da714c0545a5b28217166d07b5a6927a2c18c0f23b04b1c" => :yosemite
    sha256 "cb5c60a1268b8279277f8bda700195fb34a493f59fd57088de44d71937ccd44d" => :mavericks
  end

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  depends_on "libass"
  depends_on :python3
  depends_on "tesseract"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b1/51/bd5ef7dff3ae02a2c6047aa18d3d06df2fb8a40b00e938e7ea2f75544cac/Cython-0.24.tar.gz"
    sha256 "6de44d8c482128efc12334641347a9c3e5098d807dd3c69e867fa8f84ec2a3f1"
  end

  def install
    version = Language::Python.major_minor_version("python3")
    py3_site_packages = libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", py3_site_packages

    resource("Cython").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    ENV.prepend_create_path "PATH", libexec/"bin"

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"vspipe", "--version"
    system "python3", "-c", "import vapoursynth"
  end
end
