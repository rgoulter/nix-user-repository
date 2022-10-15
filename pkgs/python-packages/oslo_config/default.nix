{
  lib,
  buildPythonPackage,
  fetchPypi,
  debtcollector,
  netaddr,
  oslo_i18n,
  pbr,
  pyyaml,
  requests,
  rfc3986,
  stevedore,
}:
buildPythonPackage rec {
  pname = "oslo.config";
  version = "8.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q3v4yicqls9zsfxkmh5mrgz9dailaz3ir25p458gj6dg3bldhx0";
  };

  propagatedBuildInputs = [
    debtcollector
    netaddr
    oslo_i18n
    pbr
    pyyaml
    requests
    rfc3986
    stevedore
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/oslo.config/latest/";
    description = "The Oslo configuration API supports parsing command line arguments and .ini style configuration files.";
    license = licenses.asl20;
    maintainers = [];
  };
}
