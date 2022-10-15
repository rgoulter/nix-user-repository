{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
}:
buildPythonPackage rec {
  pname = "oslo.i18n";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l4mq2mk805vzs84rfmvc9arn5g4x904dpjj11j4jm3x6nk13wbb";
  };

  propagatedBuildInputs = [
    pbr
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/oslo.i18n/latest";
    description = "The oslo.i18n library contain utilities for working with internationalization (i18n) features, especially translation for text strings in an application or library.";
    license = licenses.asl20;
    maintainers = [];
  };
}
