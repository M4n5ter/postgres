{ lib
, stdenv
, fetchFromGitHub
, postgresql
, flex
, bison
, perl
}:

assert lib.elem (lib.versions.major postgresql.version) [ "15" ];

stdenv.mkDerivation rec {
  pname = "age";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "age";
    rev = "89e90671bb34439d21a6abe49d1c08aa76c7f014";
    hash = "sha256-B0DRtkxxrQjPB6xbg2an7k7wT2hJ4p1c9JkNc6vgF60=";
  };

  buildInputs = [ postgresql ];
  nativeBuildInputs = [ flex bison perl ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/share/postgresql/extension
    install -Dm755 age${postgresql.dlSuffix} $out/lib/${pname}-${version}${postgresql.dlSuffix}
    ln -s ${pname}-${version}${postgresql.dlSuffix} $out/lib/${pname}${postgresql.dlSuffix}
    install -Dm644 age.control $out/share/postgresql/extension/age.control
    shopt -s nullglob
    for sql in age--*.sql; do
      install -Dm644 "$sql" "$out/share/postgresql/extension/\${sql##*/}"
    done
    shopt -u nullglob
    runHook postInstall
  '';

  meta = with lib; {
    description = "Apache AGE graph database extension for PostgreSQL";
    homepage = "https://age.apache.org/";
    license = licenses.asl20;
    platforms = postgresql.meta.platforms;
  };
}
