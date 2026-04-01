/**
 * Builds the admin Flutter web app and copies legal static pages into build/web/
 * so Firebase Hosting serves:
 *   /              -> admin dashboard (main_admin.dart)
 *   /privacy.html, /terms.html, /support.html -> static HTML
 *
 * Run from repo root:
 *   node scripts/build-web-admin-hosting.js
 * Then:
 *   firebase deploy --only hosting
 */
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..');
const buildWebDir = path.join(root, 'build', 'web');
const docsDir = path.join(root, 'docs');
const legalFiles = ['privacy.html', 'terms.html', 'support.html'];

execSync('flutter build web --release --target=lib/main_admin.dart --no-tree-shake-icons --no-wasm-dry-run', {
  cwd: root,
  stdio: 'inherit',
});

for (const file of legalFiles) {
  const src = path.join(docsDir, file);
  const dest = path.join(buildWebDir, file);
  if (!fs.existsSync(src)) {
    console.warn(`Warning: ${src} not found, skipping.`);
    continue;
  }
  fs.copyFileSync(src, dest);
  console.log(`Copied ${file} -> build/web/`);
}

console.log('Admin web + legal pages ready. Run: firebase deploy --only hosting');
