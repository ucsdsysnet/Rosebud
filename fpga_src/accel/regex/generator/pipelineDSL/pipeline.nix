{ mkDerivation, base, stdenv, transformers }:
mkDerivation {
  pname = "pipeline";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base transformers ];
  executableHaskellDepends = [ base transformers ];
  description = "DSL for describing hardware pipelines";
  license = stdenv.lib.licenses.bsd3;
}
