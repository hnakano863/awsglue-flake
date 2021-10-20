{ lib, maven, stdenv, src, pname, version }:

stdenv.mkDerivation rec {

  name = "${pname}-${version}-maven-repo";
  inherit src;

  nativeBuildInputs = [ maven ];

  installPhase = ''
    mkdir -p $out
    mvn -f pom.xml -Dmaven.repo.local=$out/.m2 -DoutputDirectory=$out/jars dependency:copy-dependencies
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "71V79De0IObTMP/m8OGKGyaWMlCDqen2URSpierLUco=";
  dontFixup = true;
}
