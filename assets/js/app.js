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

// Set up LiveView
import { Socket } from 'phoenix'
import LiveSocket from 'phoenix_live_view'
import topbar from 'topbar'

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

const Hooks = {}

Hooks.SelectTicker = {
  updated () {
    const article = this.el.parentElement
    const script = article.querySelector('script')
    if (script) { eval(script.innerText) }
  }
}

const liveSocket = new LiveSocket('/live', Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' })
window.addEventListener('phx:page-loading-start', info => topbar.show())
window.addEventListener('phx:page-loading-stop', info => topbar.hide())

// Connect if there are any LiveViews on the page
liveSocket.connect()

// Expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
// The latency simulator is enabled for the duration of the browser session.
// Call disableLatencySim() to disable:
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

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
