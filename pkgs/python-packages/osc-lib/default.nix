{ lib
, buildPythonPackage
, fetchPypi
, cliff
, keystoneauth1
, openstacksdk
, oslo_i18n
, oslo_utils
, simplejson
}:

buildPythonPackage rec {
  pname = "osc-lib";
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s691ka6w8l5hpr67h9j8ahc8p181zh39wayd8588ih6wpik1dfn";
  };

  propagatedBuildInputs = [
    cliff
    keystoneauth1
    openstacksdk
    oslo_i18n
    oslo_utils
    simplejson
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/osc-lib/latest/";
    description = "a command-line client for OpenStack. osc-lib is a package of common support modules for writing OSC plugins.";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
