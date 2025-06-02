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
  footer: self => self.info.title,
  footer-alt: self => self.info.subtitle,
  navigation: "mini-slides",
  primary: rgb("#5277C3"),
  secondary: rgb("#7EBAE4"),
  text-font: "Libertinus Serif",
  // text-size: 20pt,
  code-font: "Iosevka Term SS15",
  // code-size: 16pt,

  config-info(
    title: [Software Reproducibility],
    subtitle: [with Docker],
    author: [leiserfg],
    institution: [shore GmbH],
  ),
  config-common(
    new-section-slide-fn: new-section-with-bar,
    preamble: {
      codly(zebra-fill: none, languages: codly-languages)
    },
    // show-notes-on-second-screen: right,
  ),
)

#title-slide()

= #smallcaps("Software Reproducibility")

== New slide

```Dockerfile
FROM ubuntu:luna
RUN apt update && apt install nodejs
```

#title-slide(title: [Nix solves that], subtitle: [], author: [leiserfg])

= #smallcaps("What is this")


== una

#speaker-note[
  + This is a speaker note.
  + You won't see it unless you use
]

Voz en off: it wasn't.


= otra

= otra más
