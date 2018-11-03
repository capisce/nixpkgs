{ stdenv, fetchFromGitHub, fetchpatch, pkgs
, ccid, opensc, openssl, qttools, qttranslations
, pkgconfig, pcsclite, hicolor-icon-theme
}:

stdenv.mkDerivation rec {

  version = "1.0.7.0";
  name = "chrome-token-signing-${version}";

  src = fetchFromGitHub {
    owner = "open-eid";
    repo = "chrome-token-signing";
    rev = "v1.0.7";
    sha256 = "1icbr5gyf7qqk1qjgcrf6921ws84j5h8zrpzw5mirq4582l5gsav";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ccid pcsclite opensc openssl
                  qttools qttranslations
                  hicolor-icon-theme
                ];

  patchPhase = ''
    substituteInPlace ./host-shared/PKCS11Path.cpp \
    --replace "\"opensc-pkcs11.so\"" "\"${pkgs.opensc}/lib/opensc-pkcs11.so\""
  '';

  installPhase = ''
    cd host-linux
    for f in ee.ria.esteid.json ff/ee.ria.esteid.json; do
      substituteInPlace $f --replace "/usr" "$out"
    done
    install -D -t $out/bin chrome-token-signing
    install -D -t $out/lib/mozilla/native-messaging-hosts ff/ee.ria.esteid.json
    install -D -t $out/etc/chromium/native-messaging-hosts ee.ria.esteid.json
    install -D -t $out/etc/opt/chrome/native-messaging-hosts ee.ria.esteid.json
  '';

  meta = with stdenv.lib; {
    description = "Chrome and Firefox extension for signing with your eID on the web";
    homepage = http://www.id.ee/;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
