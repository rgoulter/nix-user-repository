{
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      # dockerCompat = true;
    };
    virtualbox.host.enable = true;
  };
}
