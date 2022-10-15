{
  lib,
  buildPythonPackage,
  fetchPypi,
  keystoneauth1,
  oslo_i18n,
  oslo_utils,
  pbr,
  prettytable,
  simplejson,
}:
buildPythonPackage rec {
  pname = "python-cinderclient";
  version = "8.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bgq5c5pzr7nr1idmi41v853sb8x44is0sd5h8j1q5n958ml6yxm";
  };

  propagatedBuildInputs = [
    keystoneauth1
    oslo_i18n
    oslo_utils
    pbr
    prettytable
    simplejson
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/python-cinderclient/latest/";
    description = "This is a client for the OpenStack Cinder API.";
    license = licenses.asl20;
    maintainers = [];
  };
}
