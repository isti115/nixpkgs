{ lib
, stdenv
, fetchurl
, makeWrapper
, ncurses
, readline
, util-linux
, enableReadline ? true
}:

stdenv.mkDerivation rec {
  pname = "calc";
  version = "2.14.1.5";

  src = fetchurl {
    urls = [
      "https://github.com/lcn2/calc/releases/download/v${version}/calc-${version}.tar.bz2"
      "http://www.isthe.com/chongo/src/calc/calc-${version}.tar.bz2"
    ];
    sha256 = "sha256-bPacYnEJBdQsIP+Z8D/ODskyEcvhgAy3ra4wasYMo6A=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-install_name ''${LIBDIR}/libcalc''${LIB_EXT_VERSION}' '-install_name ''${T}''${LIBDIR}/libcalc''${LIB_EXT_VERSION}' \
      --replace '-install_name ''${LIBDIR}/libcustcalc''${LIB_EXT_VERSION}' '-install_name ''${T}''${LIBDIR}/libcustcalc''${LIB_EXT_VERSION}'
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ util-linux ]
             ++ lib.optionals enableReadline [ readline ncurses ];

  makeFlags = [
    "T=$(out)"
    "INCDIR="
    "BINDIR=/bin"
    "LIBDIR=/lib"
    "CALC_SHAREDIR=/share/calc"
    "CALC_INCDIR=/include"
    "MANDIR=/share/man/man1"

    # Handle LDFLAGS defaults in calc
    "DEFAULT_LIB_INSTALL_PATH=$(out)/lib"
  ] ++ lib.optionals enableReadline [
    "READLINE_LIB=-lreadline"
    "USE_READLINE=-DUSE_READLINE"
  ];

  meta = {
    homepage = "http://www.isthe.com/chongo/tech/comp/calc/";
    description = "C-style arbitrary precision calculator";
    changelog = "https://github.com/lcn2/calc/blob/v${version}/CHANGES";
    # The licensing situation depends on readline (see section 3 of the LGPL)
    # If linked against readline then GPLv2 otherwise LGPLv2.1
    license = if enableReadline
              then lib.licenses.gpl2Only
              else lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ matthewbauer ];
    platforms = lib.platforms.all;
  };
}
