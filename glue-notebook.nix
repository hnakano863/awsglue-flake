{ runCommand, makeWrapper, python, jupyter, awsglue }:

let

  definitions.python3 = {
    displayName = "Python 3 (AWS Glue)";
    argv = [
      "${python.interpreter}"
      "-m" "ipykernel_launcher"
      "-f" "{connection_file}"
    ];
    language = "python";
    logo32 = "${python.out}/${python.sitePackages}/ipykernel/resources/logo-32x32.png";
    logo64 = "${python.out}/${python.sitePackages}/ipykernel/resources/logo-64x64.png";
  };

  cmd = jupyter.override { inherit definitions; };

in

runCommand "glue-notebook" {
  buildInputs = [ awsglue cmd ];
  nativeBuildInputs = [ makeWrapper ];
} ''
  mkdir -p $out/bin/
  makeWrapper ${awsglue}/bin/gluepyspark $out/bin/glue-notebook \
    --set PYSPARK_DRIVER_PYTHON ${cmd}/bin/jupyter-notebook \
    --set PYSPARK_DRIVER_PYTHON_OPTS '--no-browser'
''
