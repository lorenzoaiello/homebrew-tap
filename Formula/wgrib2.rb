class WGrib2 < Formula
  desc "Utility to read and write grib2 files"
  homepage "https://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/"
  url "https://www.ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz"
  version "2.0.9"
  sha256 "5e6a0d6807591aa2a190d35401606f7e903d5485719655aea1c4866cc2828160"

  depends_on :xcode
  depends_on "gcc" => "10"
  depends_on "mysql-client"

  fails_with :clang

  def install

    # Setup path and environment variables needd for the MYSQL integration
    ENV.prepend_path "PATH", "/usr/local/opt/mysql-client/bin"
    ENV.append "LDFLAGS", "-L/usr/local/opt/mysql-client/lib"
    ENV.append "CPPFLAGS", "-I/usr/local/opt/mysql-client/include"

    ENV.append "CC", "gcc-10"
    ENV.append "FC", "gfortran"

    # Override default makefile data
    inreplace "makefile" do |s|

      # Configure Compilers
      s.gsub! "#export CC=gcc", "export CC=gcc-10"
      s.gsub! "#export FC=gfortran", "export FC=gfortran"

      # Enable MySQL integration
      s.gsub! "USE_MYSQL=0", "USE_MYSQL=1"
    end

    # Compile wgrib2
    system "make"

    # Install binary to system
    bin.install "wgrib2/wgrib2" => "wgrib2"
  end

  test do
    system "#{bin}/wgrib2"
  end
end
