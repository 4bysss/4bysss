// Generates light and dark Pac-Man contribution-graph SVGs.
//
// The pacman-contribution-graph package expects browser globals, so jsdom
// provides a small DOM shim. The result is pure SVG and does not require
// node-canvas or raster-image generation.

import fs from "fs";
import { JSDOM } from "jsdom";

const dom = new JSDOM("<!DOCTYPE html><body></body>", {
  pretendToBeVisual: true,
});

globalThis.window = dom.window;
globalThis.document = dom.window.document;
globalThis.requestAnimationFrame = (callback) =>
  setTimeout(() => callback(Date.now()), 0);
globalThis.cancelAnimationFrame = (id) => clearTimeout(id);

const { ArcadeRenderer } = await import("pacman-contribution-graph");

const owner = process.env.OWNER;
const token = process.env.GH_TOKEN;

if (!owner) {
  console.error("OWNER environment variable is required.");
  process.exit(1);
}

function generate(theme, outputFile) {
  return new Promise((resolve, reject) => {
    let latestSvg = "";
    let finished = false;

    const finish = () => {
      if (finished) return;
      finished = true;

      if (!latestSvg) {
        reject(new Error(`Pac-Man generated an empty SVG for ${outputFile}.`));
        return;
      }

      fs.writeFileSync(outputFile, latestSvg, "utf8");
      console.log(`Wrote ${outputFile} (${latestSvg.length} bytes).`);
      resolve();
    };

    const renderer = new ArcadeRenderer({
      game: "pacman",
      username: owner,
      platform: "github",
      gameTheme: theme,
      playerStyle: "opportunistic",
      githubSettings: token ? { accessToken: token } : undefined,
      svgCallback: (svg) => {
        latestSvg = svg;
      },
      gameOverCallback: finish,
    });

    renderer.start();

    // Safety net in case the library does not emit gameOverCallback.
    setTimeout(() => {
      if (latestSvg) finish();
      else reject(new Error(`Timed out while generating ${outputFile}.`));
    }, 90_000);
  });
}

fs.mkdirSync("dist", { recursive: true });
await generate("github", "dist/pacman.svg");
await generate("github-dark", "dist/pacman-dark.svg");
