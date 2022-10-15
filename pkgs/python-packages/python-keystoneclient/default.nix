{
  lib,
  buildPythonPackage,
  fetchPypi,
  keystoneauth1,
  oslo_config,
  oslo_serialization,
  requests,
  pbr,
  six,
}:
buildPythonPackage rec {
  pname = "python-keystoneclient";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mdasfpif756qysax6ymmq41kxqwdvbw93iijkf20g751iwvf2gx";
  };

  propagatedBuildInputs = [
    keystoneauth1
    oslo_config
    oslo_serialization
    requests
    pbr
    six
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/python-keystoneclient/latest/";
    description = "This is a client for the OpenStack Identity API, implemented by the Keystone team.";
    license = licenses.asl20;
    maintainers = [];
  };
}
