// dester login helper: opens a VISIBLE browser; the human signs in; the session is saved outside the project.
// Usage: SITE=https://app.example.com SESSION=~/.dester-sessions/<project>.json node login.mjs
// Never types credentials. The session file is a secret: never print it, never commit it.
//
// It saves the session when the first of these happens:
//   1. a password field appeared and then went away (normal email + password sign-in)
//   2. DONE_URL (a regex, e.g. "/dashboard") matches the current URL (SSO, magic link, Google sign-in)
//   3. the file "<SESSION>.done" exists (the human says "done"; whoever runs this does `touch <SESSION>.done`)
import { chromium } from 'playwright';
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';

const SITE = process.env.SITE;
if (!SITE) throw new Error('Set SITE=https://...');
const SESSION = (process.env.SESSION || path.join(os.homedir(), '.dester-sessions', 'session.json')).replace(/^~/, os.homedir());
const DONE_FILE = SESSION + '.done';
const DONE_URL = process.env.DONE_URL ? new RegExp(process.env.DONE_URL) : null;
const WAIT_MS = Number(process.env.WAIT_MS || 600000);
const CHANNEL = process.env.CHANNEL ?? 'chrome'; // installed Chrome; set CHANNEL= (empty) to use Playwright's Chromium

fs.mkdirSync(path.dirname(SESSION), { recursive: true, mode: 0o700 });
fs.rmSync(DONE_FILE, { force: true });

const browser = await chromium.launch({ headless: false, ...(CHANNEL ? { channel: CHANNEL } : {}) });
const ctx = await browser.newContext({ viewport: { width: 1360, height: 860 } });
const page = await ctx.newPage();
await page.goto(SITE);
console.log('WAITING: sign in in the opened browser window (including any 2FA), then reach a page inside the app.');

const start = Date.now();
let sawPassword = false;
let reason = '';
while (Date.now() - start < WAIT_MS) {
  const hasPassword = (await page.locator('input[type=password]').count().catch(() => 0)) > 0;
  if (hasPassword) sawPassword = true;
  if (sawPassword && !hasPassword) { reason = 'password field gone'; break; }
  if (DONE_URL && DONE_URL.test(page.url())) { reason = 'DONE_URL matched'; break; }
  if (fs.existsSync(DONE_FILE)) { reason = 'done file'; break; }
  await page.waitForTimeout(1000);
}
if (!reason) {
  console.log('Timed out waiting for sign-in. Nothing saved.');
  await browser.close();
  process.exit(1);
}
await page.waitForLoadState('networkidle').catch(() => {});
await ctx.storageState({ path: SESSION });
fs.chmodSync(SESSION, 0o600);
fs.rmSync(DONE_FILE, { force: true });
console.log(`SIGNED IN (${reason}). Session saved (not printed). Landing path:`, new URL(page.url()).pathname);
await browser.close();
