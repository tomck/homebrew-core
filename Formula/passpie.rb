class Passpie < Formula
  desc "Manage login credentials from the terminal"
  homepage "https://github.com/marcwebbie/passpie"
  url "https://files.pythonhosted.org/packages/6b/d1/e198766fee560af7d6568f213209c7f377376edaa326a7d5802ef5262aa5/passpie-1.4.3.tar.gz"
  sha256 "c6778a65fd7c1e00be94cc39a0468f04509d0c14b3686a1788f2012917b1d2fc"
  head "https://github.com/marcwebbie/passpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7afdbb1d2283fc50ea7c208772d4dbc322a42963268c7843cd1fbbc739fac7d" => :el_capitan
    sha256 "cac0e751496664be893c9bbee2888a5438040886c9452d5ba63f2cdba9ab6928" => :yosemite
    sha256 "5593e357b153fa1fd50c9e23b7b4acf1a639e65fb839a1d3943438d88062d876" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :gpg

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.2.tar.gz"
    sha256 "fba0ff70f5ebb4cebbf64c40a8fbc222fb7cf825237241e548354dabe3da6a82"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "rstr" do
    url "https://pypi.python.org/packages/source/r/rstr/rstr-2.2.3.tar.gz"
    sha256 "10a58eb08a7e3735eddc8f32f3db419797dadb6335b02b94dcd8d741363d79e9"
  end

  resource "tabulate" do
    url "https://pypi.python.org/packages/source/t/tabulate/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  resource "tinydb" do
    url "https://pypi.python.org/packages/source/t/tinydb/tinydb-3.1.2.zip"
    sha256 "6d9df6c30fc37dad487c23bfadfa6161de422a7f2b16b55d779df88559fc9095"
  end

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[click rstr tabulate tinydb PyYAML].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"passpie", "-D", "passpiedb", "init", "--force", "--passphrase", "s3cr3t"
  end
end
