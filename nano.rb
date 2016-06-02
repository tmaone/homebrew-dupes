class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "http://www.nano-editor.org/"
  url "http://www.nano-editor.org/dist/v2.5/nano-2.5.3.tar.gz"
  mirror "ftp://ftp.gnu.org/pub/gnu/nano/nano-2.5.3.tar.gz"
  sha256 "b2b060129b9feff2d4870d803a441178c96531de9aed144ec0b83bd63ccb12ee"

  bottle do
    cellar :any
    sha256 "6ab6a181b86ffe0863c73396ac48811f54dd738844a6da1ef52b36e1c5db192d" => :el_capitan
    sha256 "235dbaf011a3de72a7fcc6a3cd53eee7c72b3b62c4cfb462518c7b06d6a27cea" => :yosemite
    sha256 "d580b484b84970848c70b26c1be2ec03f61c9b43bc0bcfde7cf5b560a9bc21af" => :mavericks
  end

  head do
    url "http://git.savannah.gnu.org/r/nano.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "homebrew/dupes/ncurses"

  def install
    # Otherwise SIGWINCH will not be defined
    ENV.append_to_cflags "-U_XOPEN_SOURCE" if MacOS.version < :leopard

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--disable-nls",
                          "--enable-utf8"
    system "make", "install"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
