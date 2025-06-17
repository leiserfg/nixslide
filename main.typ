#import "@preview/touying-flow:1.2.0": *
#import "@preview/codly-languages:0.1.8": codly-languages


#let new-section-with-bar(
  config: (:),
  level: 1,
  numbered: true,
  body,
) = touying-slide-wrapper(self => {
  let slide-body = {
    set std.align(horizon)
    show: pad.with(20%)
    set text(size: 1.5em, fill: self.colors.primary, weight: "bold")
    stack(
      dir: ttb,
      spacing: .65em,
      utils.display-current-heading(level: level, numbered: numbered),
      block(height: 2pt, width: 100%, spacing: 0pt, components.progress-bar(
        height: 2pt,
        self.colors.primary,
        self.colors.primary-light,
      )),
    )
    body
  }
  touying-slide(self: self, config: config, slide-body)
})

#show: flow-theme.with(
  aspect-ratio: "16-9",
  // footer: self => self.info.title,
  // footer-alt: self => self.info.subtitle,
  navigation: "mini-slides",
  primary: rgb("#5277C3"),
  secondary: rgb("#7EBAE4"),
  text-font: "Libertinus Serif",
  // text-size: 20pt,
  code-font: "Iosevka Term SS15",
  code-size: 16pt,

  config-info(
    title: [Software Reproducibility],
    subtitle: [with Docker],
    author: [leiserfg],
    institution: [shore GmbH],
  ),
  config-common(
    new-section-slide-fn: new-section-with-bar,
    preamble: {
      codly(zebra-fill: none, languages: codly-languages, inset: 0.15em)
    },
    // show-notes-on-second-screen: right,
  ),
)


#title-slide()

= #smallcaps("Mom, I want reproducibility!")

== We have reproducibility

```Dockerfile
FROM ubuntu:luna
RUN apt update && apt install python
ENTRYPOINT python
```

```sh
$ docker build . -t the_python
$ docker run the_python --version
> Python 3.12.10
```

== At home ...

#speaker-note[
  Or do we?
]

```sh
$ docker build . -t the_python
$ docker run the_python --version
> Python 3.13.2
```

#title-slide(title: [Nix solves that], subtitle: [], author: [leiserfg])

= #smallcaps("Look ma! with nix")

== This time for real

This is a `shell.nix` file.
```nix
{
  pkgs ?
    import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/63dacb46bf939521bdc93981b4cbb7ecb58427a0.tar.gz";
    }) {},
}:
pkgs.mkShell {
  buildInputs = [ pkgs.python312 ];
}
```

===

```sh
$ nix shell
> python --version
> Python 3.12.2
```

= What is nix?

== Pure Functional Language

```nix
let
  ips = [ "192.168.1.10" "127.0.0.1" "10.0.0.5" ];
  filteredIps = builtins.filter (ip: ip != "127.0.0.1") ips;
  jsonOutput = builtins.toJSON filteredIps;
in
  jsonOutput;
```


#speaker-note[
  The language is pure, as the types are inmutables. As in, you can't modify, just create objects.
  Also it does not have any direct secondary effects (file creation, edition ...)
]

== Builder


```nix
derivation {
  name = "hello-derivation";
  builder = "/bin/sh";
  args = [ "-c" "echo Hello, Nix! > $out" ];
  system = builtins.currentSystem;
}
```

#speaker-note[
  nix (the language) does not make the stuff, just describes how to build it, that is called a derivation.
]

=== Derivation
- A receipt for building a set of files (not necesarily a binary).
- Enumerates other files that are dependencies.
- Each output, including the derivation itself, is hashed so they make a merkle tree (like git or ₿)
- They are instanciated (compiled) in a sandboxed environment.

== Package Manager

```nix
{ stdenv, fetchFromGitHub, gcc }:
stdenv.mkDerivation rec{
  pname = "hello-c";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "example";
    repo = "hello-c";
    rev = "v${version}";
    sha256 = "00000---thisisafakehash---usedfornixexamples---0000000";
  };
  buildInputs = [ gcc ];

  buildPhase = ''
    gcc $src/hello.c -o hello
    mv hello $out
  '';
}
```

#figure(
  image("./map_repo_size_fresh.svg"),
  caption: [Nixpkgs, in retopology #link("https://repology.org/repositories/graphs")],
)

#speaker-note[ asdf ]

= Made with Nix

==

=== NixOs
Linux distro using nixpkgs and where everithing is configured in nix (packages, services, users...)

=== home-manager
Tool to setup your home configuration and programs (works on nixos, plain linux and macos).

=== darwin-nix
Similar to nixos but on top of macos

== Devenv

Reproducible and declarative development environments.

```nix
{ pkgs, ... }:
{
  dotenv.enable = true;
  env.DD_TRACE_ENABLED = false;

  packages = [ pkgs.gettext];
  language.elixir.enable = true;
  git-hooks.hooks = {
    credo.enable = True;
    mif-format.enable = True;
  }
}
```
