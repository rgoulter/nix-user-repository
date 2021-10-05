{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, cryptography
, dogpile_cache
, jmespath
, jsonpatch
, keystoneauth1
, munch
, netifaces
, pbr
, pyyaml
, requestsexceptions
}:

buildPythonPackage rec {
  pname = "openstacksdk";
  version = "0.59.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03dzkb7ahx3gaw3xfkaxn9xlkg1cp3p65gnfr3xap6134z6n1xrx";
  };

  propagatedBuildInputs = [
    appdirs
    cryptography
    dogpile_cache
    jmespath
    jsonpatch
    keystoneauth1
    munch
    netifaces
    pbr
    pyyaml
    requestsexceptions
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/openstacksdk/";
    description = "openstacksdk is a client library for building applications to work with OpenStack clouds.";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
