{
  lib,
  buildPythonPackage,
  fetchPypi,
  debtcollector,
  iso8601,
  netaddr,
  netifaces,
  oslo_i18n,
  packaging,
  pbr,
  pyparsing,
  pytz,
}:
buildPythonPackage rec {
  pname = "oslo.utils";
  version = "4.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jvjwffaa48jkdszh133sx9w8fiasdhgpb033gr7k2nh1rbyciln";
  };

  propagatedBuildInputs = [
    debtcollector
    iso8601
    netaddr
    netifaces
    oslo_i18n
    packaging
    pbr
    pyparsing
    pytz
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/oslo.utils/latest/";
    description = "The oslo.utils library provides support for common utility type functions, such as encoding, exception handling, string manipulation, and time handling.";
    license = licenses.asl20;
    maintainers = [];
  };
}
