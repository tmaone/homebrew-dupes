class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "http://ftpmirror.gnu.org/grep/grep-2.23.tar.xz"
  mirror "https://ftp.gnu.org/gnu/grep/grep-2.23.tar.xz"
  sha256 "54fc478ee1ce17780109820ef30730c9e18715a949f7d5c6afc673adb2a56ecf"

  bottle do
    cellar :any
    sha256 "4e672c73d2e5662c9aab4bd48e67d30993d42e72c2fe7109010a3ef38481240d" => :el_capitan
    sha256 "bc2cccae7ecc7ae6ad1bd068c922672478b4d701477c40ac2a2789ece7b49c07" => :yosemite
    sha256 "d3edd2f5d9621dfda54749542c72ba645dc2ce25a751c91efda909badbd34025" => :mavericks
  end

  option "with-default-names", "Do not prepend 'g' to the binary"
  deprecated_option "default-names" => "with-default-names"

  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats
    if build.without? "default-names" then <<-EOS.undent
      The command has been installed with the prefix "g".
      If you do not want the prefix, install using the "with-default-names"
      option.
      EOS
    end
  end

  test do
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"
    cmd = build.with?("default-names") ? "grep" : "ggrep"
    grepped = shell_output("#{bin}/#{cmd} match #{text_file}")
    assert_match "should be matched", grepped
  end
end
