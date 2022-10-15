{
  lib,
  buildPythonPackage,
  fetchPypi,
  msgpack,
  oslo_utils,
  pbr,
  pytz,
}:
buildPythonPackage rec {
  pname = "oslo.serialization";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10sdgvyb0d3lcmb8b4l5gs40bkfbai08kvsdwp658dxd2yqf21rh";
  };

  propagatedBuildInputs = [
    msgpack
    oslo_utils
    pbr
    pytz
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/oslo.serialization/latest/";
    description = "The oslo.serialization library provides support for representing objects in transmittable and storable formats, such as Base64, JSON and MessagePack.";
    license = licenses.asl20;
    maintainers = [];
  };
}
