// Follow the caelestia scheme without re-spicing Spotify. The package links
// Apps/xpui/caelestia.css to ~/.local/state/caelestia/theme/spicetify.css,
// which caelestia rewrites on every scheme change; re-read it so its --spice-*
// variables replace the baked-in colors.css ones (by specificity, see the
// templates: Spotify moves colors.css to the end of <body>).
(function caelestiaColours() {
  const style = document.createElement("style");
  style.id = "caelestia-colours";
  document.head.appendChild(style);

  let last = "";
  async function update() {
    if (document.hidden) return;
    try {
      const res = await fetch("caelestia.css", { cache: "no-store" });
      if (!res.ok) return;
      const css = await res.text();
      if (css !== last) style.textContent = last = css;
    } catch {
      // Not rendered yet (no scheme applied since install); keep the baked-in colours.
    }
  }

  update();
  setInterval(update, 2000);
  document.addEventListener("visibilitychange", update);
})();
