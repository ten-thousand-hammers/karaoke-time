import { Controller } from "@hotwired/stimulus"
// import FingerprintJS from '@fingerprintjs/fingerprintjs'

export default class extends Controller {


  connect() {
    this.version = 1
    this.load();
  }

  async load() {
    if (this.cookieExists('_karaoke_time_browser_id')) {
      // console.log('Browser ID already exists');
      var cookieValue = this.getCookie('_karaoke_time_browser_id');
      if (cookieValue.indexOf("{") === 0 || cookieValue.indexOf("%7B") === 0) {
        cookieValue = JSON.parse(decodeURIComponent(cookieValue));
      }

      if (typeof cookieValue !== 'object') {
        // console.log(`Browser ID is not an object: ${typeof cookieValue} - ${cookieValue}`);
        this.removeCookie('_karaoke_time_browser_id');
        cookieValue = {}
      }

      if (cookieValue.version === this.version) {
        // console.log(`Browser ID version is up to date: ${cookieValue.id}`);
        return;
      }

      // console.log('Browser ID version is outdated');
      this.removeCookie('_karaoke_time_browser_id');
      cookieValue = {}
    }

    // const fpPromise = await FingerprintJS.load()
    // const fp = await fpPromise.get()

    var uniqueId;
    // var uniqueId = fp.visitorId;
    if (uniqueId == null) {
      uniqueId = crypto.randomUUID();
    }

    this.setCookie(
      '_karaoke_time_browser_id',
      JSON.stringify({
        version: this.version,
        id: uniqueId
      }),
      30 // Cookie expires in 30 days
    );
  }

  cookieExists(name) {
    return document.cookie.indexOf(name) > -1;
  }

  getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
  }

  setCookie(name, value, days) {
    const expires = new Date(Date.now() + days * 864e5).toUTCString();
    document.cookie = name + '=' + encodeURIComponent(value) + '; expires=' + expires + '; path=/';
  }

  removeCookie(name) {
    document.cookie = name + '=; Max-Age=-99999999;';
  }
}
