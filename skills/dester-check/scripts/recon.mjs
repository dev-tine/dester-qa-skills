// dester recon: READ-ONLY crawl of internal links after the human signed in. It only navigates (GET); it never
// clicks buttons, submits forms, or follows logout/delete/remove-like links.
// Usage: SITE=https://app.example.com SESSION=~/.dester-sessions/x.json OUT=./evidence START=/dashboard node recon.mjs
import { chromium } from 'playwright';
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';

const SITE = (process.env.SITE || '').replace(/\/$/, '');
if (!SITE) throw new Error('Set SITE=https://...');
const SESSION = (process.env.SESSION || path.join(os.homedir(), '.dester-sessions', 'session.json')).replace(/^~/, os.homedir());
const OUT = path.resolve(process.env.OUT || './evidence');
const START = process.env.START || '/';
const MAXPAGES = Number(process.env.MAXPAGES || 40);
const CHANNEL = process.env.CHANNEL || 'chrome';
const SKIP = new RegExp(process.env.SKIP || 'logout|signout|sign-out|log-out|delete|remove|unsubscribe|revoke|reset', 'i');

fs.mkdirSync(OUT, { recursive: true });
const browser = await chromium.launch({ headless: true, ...(CHANNEL ? { channel: CHANNEL } : {}) });
const ctx = await browser.newContext({ storageState: SESSION, viewport: { width: 1360, height: 860 } });
const page = await ctx.newPage();

async function snapshot(p) {
  await page.goto(SITE + p, { waitUntil: 'networkidle', timeout: 30000 }).catch(() => {});
  const url = new URL(page.url());
  const data = await page.evaluate(() => {
    const t = (e) => (e.innerText || e.getAttribute('aria-label') || '').trim().replace(/\s+/g, ' ').slice(0, 80);
    const main = document.querySelector('main') || document.body;
    return {
      title: document.title,
      headings: [...document.querySelectorAll('h1,h2,h3')].map(t).filter(Boolean).slice(0, 20),
      links: [...document.querySelectorAll('a[href]')].map((a) => ({ text: t(a), href: a.getAttribute('href') })),
      buttons: [...main.querySelectorAll('button,[role=button],[role=tab]')].map(t).filter(Boolean).slice(0, 40),
      tableHeaders: [...document.querySelectorAll('th')].map(t).filter(Boolean).slice(0, 30),
      fields: [...document.querySelectorAll('input,select,textarea')]
        .filter((e) => e.type !== 'password' && e.type !== 'hidden')
        .map((e) => ({ type: e.type || e.tagName.toLowerCase(), label: e.getAttribute('aria-label') || e.placeholder || e.name || '' }))
        .slice(0, 30),
      mainText: main.innerText.replace(/\s+/g, ' ').slice(0, 800),
    };
  });
  const slug = url.pathname.replace(/\W+/g, '_').replace(/^_|_$/g, '') || 'home';
  await page.screenshot({ path: path.join(OUT, `p_${slug}.png`), fullPage: true }).catch(() => {});
  return { requested: p, landed: url.pathname, ...data, shot: `p_${slug}.png` };
}

const seen = new Map();
const queue = [START];
while (queue.length && seen.size < MAXPAGES) {
  const p = queue.shift();
  if (seen.has(p)) continue;
  const snap = await snapshot(p);
  seen.set(p, snap);
  for (const l of snap.links) {
    let h = l.href;
    if (!h || h.startsWith('#') || /^(mailto|tel|javascript):/.test(h)) continue;
    if (h.startsWith(SITE)) h = h.slice(SITE.length);
    if (!h.startsWith('/')) continue; // external: out of scope
    h = h.split('#')[0].split('?')[0];
    if (SKIP.test(h)) continue;
    if (!seen.has(h) && !queue.includes(h)) queue.push(h);
  }
}
fs.writeFileSync(path.join(OUT, 'recon.json'), JSON.stringify([...seen.values()], null, 1));
for (const s of seen.values()) {
  console.log(`${s.requested}${s.landed !== s.requested ? ' -> ' + s.landed : ''} | ${s.headings.slice(0, 2).join(' / ')} | btn: ${s.buttons.slice(0, 5).join(', ')} | th: ${s.tableHeaders.slice(0, 5).join(', ')}`);
}
console.log(`pages: ${seen.size}, left in queue: ${queue.length}`);
await browser.close();
