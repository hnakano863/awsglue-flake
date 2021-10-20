{ lib, stdenvNoCC, fetchzip, coreutils }:

stdenvNoCC.mkDerivation rec {

  pname = "spark";
  version = "3.1.1-amzn-0";
  hadoop-version = "3.2.1-amzn-3";

  src = fetchzip {
    url    = "https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-3.0/${pname}-${version}-bin-${hadoop-version}.tgz";
    sha256 = "E5kgVxL2RBymz2mhYvyF1s4kR5554+HXrsIwlFeoiA8=";
  };

  patchPhase = ''
    for n in $(find bin -type f ! -name "*.*"); do
      substituteInPlace "$n" --replace dirname ${coreutils.out}/bin/dirname
    done
  '';

  installPhase = ''
    mkdir -p $out
    mv * $out
  '';

}
