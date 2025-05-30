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
    pkgs.pympress
  ];

  languages.typst = {
    enable = true;
    fontPaths = [
      "${(pkgs.iosevka-bin.override { variant = "SGr-IosevkaSS15"; })}/share/fonts/truetype"
      "${pkgs.noto-fonts-emoji}/share/fonts/noto"
    ];
  };

}
