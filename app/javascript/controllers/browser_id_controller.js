import { Controller } from "@hotwired/stimulus"
import FingerprintJS from '@fingerprintjs/fingerprintjs'

export default class extends Controller {
  connect() {
    this.load();
  }

  async load() {
    if (document.cookie.indexOf('_karaoke_time_browser_id') > -1) {
      return;
    }

    const fpPromise = await FingerprintJS.load()
    const fp = await fpPromise.get()

    var uniqueId = fp.visitorId;
    if (uniqueId == null) {
      uniqueId = crypto.randomUUID();
    }

    this.setCookie('_karaoke_time_browser_id', uniqueId, 30); // Cookie expires in 30 days
  }

  setCookie(name, value, days) {
    const expires = new Date(Date.now() + days * 864e5).toUTCString();
    document.cookie = name + '=' + encodeURIComponent(value) + '; expires=' + expires + '; path=/';
  }
}
