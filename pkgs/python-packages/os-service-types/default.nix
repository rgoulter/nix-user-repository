{ lib
, buildPythonPackage
, fetchPypi
, pbr
}:

buildPythonPackage rec {
  pname = "os-service-types";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v4chwr5jykkvkv4w7iaaic7gb06j6ziw7xrjlwkcf92m2ch501i";
  };

  propagatedBuildInputs = [
    pbr
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/os-service-types/latest/";
    description = "Python library for consuming OpenStack sevice-types-authority data";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
