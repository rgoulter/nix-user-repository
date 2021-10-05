{ lib
, buildPythonPackage
, fetchPypi
, keystoneauth1
, oslo_serialization
, pbr
, prettytable
}:

buildPythonPackage rec {
  pname = "python-novaclient";
  version = "17.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x9hyb235mm39ka7k3rwrgwz0bvif085yn23ndgn7nhhac4c4469";
  };

  propagatedBuildInputs = [
    keystoneauth1
    oslo_serialization
    pbr
    prettytable
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/python-novaclient/latest";
    description = "This is a client for the OpenStack Compute API.";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
