{ lib
, buildPythonPackage
, fetchPypi
, osc-lib
, pbr
, python-cinderclient
, python-keystoneclient
, python-novaclient
}:

buildPythonPackage rec {
  pname = "python-openstackclient";
  version = "5.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1slpr5m22p6cd40i2dljj5m29djgaal1adf87sw7snlc6xk6dg0a";
  };

  propagatedBuildInputs = [
    osc-lib
    pbr
    python-cinderclient
    python-keystoneclient
    python-novaclient
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/python-openstackclient/latest/";
    description = "a command-line client for OpenStack that brings the command set for Compute, Identity, Image, Object Storage and Block Storage APIs together in a single shell with a uniform command structure.";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
