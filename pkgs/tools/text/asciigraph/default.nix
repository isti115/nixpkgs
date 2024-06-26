{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "asciigraph";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "guptarohit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZmH0+UXPUyO90ZI6YsKiTd6Nf8dgZAgm7Qx8PVUkHAU=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/guptarohit/asciigraph";
    description = "Lightweight ASCII line graph ╭┈╯ command line app";
    mainProgram = "asciigraph";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmahut ];
  };
}
