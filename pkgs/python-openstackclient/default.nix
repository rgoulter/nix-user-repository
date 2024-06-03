{
  lib,
  python3,
}:
with lib; let
  os-service-types = ps: ps.callPackage ../python-packages/os-service-types {};
  keystoneauth1 = ps: ps.callPackage ../python-packages/keystoneauth1 {};
  oslo_i18n = ps: ps.callPackage ../python-packages/oslo_i18n {};
  debtcollector = ps: ps.callPackage ../python-packages/debtcollector {};
  oslo_utils = ps: ps.callPackage ../python-packages/oslo_utils {};
  openstacksdk = ps: ps.callPackage ../python-packages/openstacksdk {};
  osc-lib = ps: ps.callPackage ../python-packages/osc-lib {};
  oslo_serialization = ps: ps.callPackage ../python-packages/oslo_serialization {};
  oslo_config = ps: ps.callPackage ../python-packages/oslo_config {};
  python-keystoneclient = ps: ps.callPackage ../python-packages/python-keystoneclient {};
  python-novaclient = ps: ps.callPackage ../python-packages/python-novaclient {};
  python-cinderclient = ps: ps.callPackage ../python-packages/python-cinderclient {};
  python-openstackclient = ps: ps.callPackage ../python-packages/python-openstackclient {};
  my-python-packages = python-packages:
    with python-packages; [
      appdirs
      cliff
      cryptography
      dogpile_cache
      iso8601
      jmespath
      jsonpatch
      msgpack
      munch
      netaddr
      netifaces
      packaging
      pbr
      prettytable
      pyparsing
      pytz
      pyyaml
      requests
      requestsexceptions
      rfc3986
      simplejson
      six
      stevedore
      wrapt
      (os-service-types python-packages)
      (keystoneauth1 python-packages)
      (oslo_i18n python-packages)
      (debtcollector python-packages)
      (oslo_utils python-packages)
      (openstacksdk python-packages)
      (osc-lib python-packages)
      (oslo_serialization python-packages)
      (oslo_config python-packages)
      (python-keystoneclient python-packages)
      (python-novaclient python-packages)
      (python-cinderclient python-packages)
      (python-openstackclient python-packages)
    ];
  python-with-my-packages = python3.withPackages my-python-packages;
in
  python-with-my-packages.pkgs.python-openstackclient
