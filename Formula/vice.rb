class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://sourceforge.net/projects/vice-emu/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.6.tar.gz"
  sha256 "65bfe55cce627db9b5a0ac7876a90c087e9fe86e9f5517e809446c4064a2d3fd"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  livecheck do
    url :stable
    regex(%r{url=.*?/vice[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 monterey: "50ff8e44e61eaf98b9f11ab69191b8788519e92c907f906fbe86858482397f1f"
    sha256 big_sur:  "c07d71cebd01929ae44bb80611d761c10c5f8ae53b2ac8e855d2a77bb9ce2270"
    sha256 catalina: "32421c80ed1f4fd835143587ec1d666941aadaefa2ea5facd2bbd2355cc078c4"
    sha256 mojave:   "04964db736a6895edf14f3e0d1cd8dce585c18b56dd123f6376bb2743a1d9953"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "dos2unix" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build

  depends_on "adwaita-icon-theme"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "glew"
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libvorbis"

  def install
    configure_flags = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-arch
      --disable-pdf-docs
      --enable-native-gtk3ui
      --enable-midi
      --enable-lame
      --enable-external-ffmpeg
      --enable-ethernet
      --enable-cpuhistory
      --with-flac
      --with-vorbis
      --with-gif
      --with-jpeg
      --with-png
    ]

    system "./autogen.sh"
    system "./configure", *configure_flags
    system "make", "install"
  end

  test do
    assert_match "cycle limit reached", shell_output("#{bin}/x64sc -console -limitcycles 1000000 -logfile -", 1)
  end
end
