import Trix from "trix"

Trix.config.lang = {
  attachFiles: "Alkroĉi dosierojn",
  bold: "Grasigi",
  bullets: "Bula listo",
  byte: "bajto",
  bytes: "bajtoj",
  captionPlaceholder: "Aldoni apudskribon…",
  code: "Kodo",
  heading1: "Titolo",
  indent: "Altigi nivelon",
  italic: "Kursivigi",
  link: "Ligi",
  numbers: "Numera listo",
  outdent: "Malaltigi nivelon",
  quote: "Citaĵo",
  redo: "Refari",
  remove: "Forigi",
  strike: "Trastreki",
  undo: "Malfari",
  unlink: "Malligi",
  url: "Ligilo",
  urlPlaceholder: "Entajpu ligilon…",
  GB: "GB",
  KB: "kB",
  MB: "MB",
  PB: "PB",
  TB: "TB"
}

document.addEventListener("DOMContentLoaded", () => {
  const atribuoj = {
    bold: "Grasigi",
    italic: "Kursivigi",
    strike: "Trastreki",
    link: "Ligi",
    "heading-1": "Titolo",
    quote: "Citaĵo",
    code: "Kodo",
    "bullet-list": "Bula listo",
    "number-list": "Numera listo",
    "decrease-nesting-level": "Malaltigi nivelon",
    "increase-nesting-level": "Altigi nivelon",
    attach: "Alkroĉi dosierojn",
    undo: "Malfari",
    redo: "Refari"
  }

  for (const [key, value] of Object.entries(atribuoj)) {
    document.querySelector(`.trix-button--icon-${key}`).setAttribute("title", value)
  }

  const ligilajKampoj = document.querySelector(".trix-dialog__link-fields")

  // Por entajpi ligilojn
  ligilajKampoj.querySelector(".trix-input--dialog").setAttribute("placeholder", "Entajpu ligilon…")
  ligilajKampoj.querySelector("[data-trix-method='setAttribute']").setAttribute("value", "Ligi")
  ligilajKampoj.querySelector("[data-trix-method='removeAttribute']").setAttribute("value", "Malligi")
}, false)

export default Trix
