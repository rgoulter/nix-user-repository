{ lib
, buildPythonPackage
, fetchPypi
, iso8601
, os-service-types
, pbr
, requests
, six
, stevedore
}:

buildPythonPackage rec {
  pname = "keystoneauth1";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0krizfzkw4pa1zk0g6hhjg98hszbsyl9jvxym8j99ckswrmjlril";
  };

  propagatedBuildInputs = [
    iso8601
    os-service-types
    pbr
    requests
    six
    stevedore
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/keystoneauth/latest/";
    description = "tools for authenticating to an OpenStack-based cloud.";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
