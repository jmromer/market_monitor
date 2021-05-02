// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.scss'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import 'phoenix_html'

// Update body background size and position dynamically based on
// orientation and aspect ratio. An expedient alternative to a Canvas-rendered
// background.
const body = document.querySelector('body')
const bgPositions = ['center', 'left', 'right', 'top']
const mediaQuery = 'only screen and (min-aspect-ratio: 5/4)'

window.matchMedia(mediaQuery).addListener(mql => {
  if (mql.matches) {
    body.style.backgroundPosition = 'unset'
    body.style.backgroundSize = 'cover'
  } else {
    body.style.backgroundPosition = bgPositions[Math.floor(Math.random() * 4)]
    body.style.backgroundSize = 'auto'
  }
})
