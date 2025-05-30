{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = [
    pkgs.tinymist
  ];

  languages.typst = {
    enable = true;
  };

}
