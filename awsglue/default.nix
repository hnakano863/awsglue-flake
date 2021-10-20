{ lib
, stdenv
, callPackage
, runCommand
, makeWrapper
, fetchFromGitHub
, zip
, jre
, python
}:

let

  pname = "aws-glue-libs";
  version = "v3.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "nz92j+qeA16evxwzSQ23jigVE/VRvx5bMKVxthVDqa8=";
  };

  repo = callPackage ./gluerepo.nix { inherit pname version src; };

  spark = callPackage ./amazon-spark.nix { };

in

stdenv.mkDerivation rec {

  inherit pname version src;

  nativeBuildInputs = [ zip makeWrapper ];

  buildInputs = [ jre python ];

  buildPhase = ''
    zip -r PyGlue.zip awsglue
  '';

  installPhase = ''
    mkdir -p $out/{lib,conf,bin}
    mv PyGlue.zip $out/lib/

    cat > $out/conf/spark-defaults.conf <<- EOF
    spark.driver.extraClassPath ${repo}/jars/*
    spark.executor.extraClassPath ${repo}/jars/*
    EOF

    cat > $out/conf/spark-env.sh <<- EOF
    export JAVA_HOME="${jre}"
    export SPARK_HOME="${spark}"
    export PYSPARK_PYTHON="${python.interpreter}"
    export PYTHONPATH="$out/lib/PyGlue.zip"
    EOF

    makeWrapper ${spark}/bin/pyspark $out/bin/gluepyspark \
      --set SPARK_CONF_DIR "$out/conf"
  '';

  meta = with lib; {
    description = "AWS Glue Libraries are additions and enhancements to Spark for ETL operations.";
    homepage = "https://aws.amazon.com/glue/";
    license = lib.licenses.amazonsl;
  };
}
