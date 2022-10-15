{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  six,
  wrapt,
}:
buildPythonPackage rec {
  pname = "debtcollector";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ikqjq0z00visdcdl1bwsbkhgjbc6lc6nl8577i08ndb2k4gmaf7";
  };

  propagatedBuildInputs = [
    pbr
    six
    wrapt
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.openstack.org/debtcollector/latest";
    description = "A collection of Python deprecation patterns and strategies that help you collect your technical debt in a non-destructive manner.";
    license = licenses.asl20;
    maintainers = [];
  };
}
