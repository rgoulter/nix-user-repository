{
  pkgs,
  ...
}:
# Brother laser printer
{
  services.printing = {
    enable = true;
    drivers = [pkgs.brlaser];
  };
}
