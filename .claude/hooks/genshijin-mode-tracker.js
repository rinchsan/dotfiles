#!/usr/bin/env node
// genshijin — UserPromptSubmit hook
//
// On every user prompt:
//   1. Detects /genshijin commands and saves mode to flag file
//   2. Emits per-turn reminder when mode is active (prevents drift)

const fs = require('fs');
const path = require('path');
const os = require('os');

const VALID_MODES = ['丁寧', '通常', '極限'];
const DEFAULT_MODE = '通常';
const MAX_FLAG_BYTES = 32;

const claudeDir = (() => {
  const d = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude');
  try { return fs.realpathSync(d); } catch (e) { return d; }
})();
const flagPath = path.join(claudeDir, '.genshijin-mode');

// Symlink-safe flag write
function writeFlag(p, content) {
  try {
    const dir = path.dirname(p);
    fs.mkdirSync(dir, { recursive: true });

    try { if (fs.lstatSync(dir).isSymbolicLink()) return; } catch (e) { return; }
    try { if (fs.lstatSync(p).isSymbolicLink()) return; } catch (e) {
      if (e.code !== 'ENOENT') return;
    }

    const tmp = path.join(dir, `.genshijin-mode.${process.pid}.${Date.now()}`);
    const O_NOFOLLOW = typeof fs.constants.O_NOFOLLOW === 'number' ? fs.constants.O_NOFOLLOW : 0;
    const flags = fs.constants.O_WRONLY | fs.constants.O_CREAT | fs.constants.O_EXCL | O_NOFOLLOW;
    let fd;
    try {
      fd = fs.openSync(tmp, flags, 0o600);
      fs.writeSync(fd, String(content));
      try { fs.fchmodSync(fd, 0o600); } catch (e) { /* best-effort */ }
    } finally {
      if (fd !== undefined) fs.closeSync(fd);
    }
    fs.renameSync(tmp, p);
  } catch (e) { /* silent fail */ }
}

// Symlink-safe flag read
function readFlag(p) {
  try {
    let st;
    try { st = fs.lstatSync(p); } catch (e) { return null; }
    if (st.isSymbolicLink() || !st.isFile()) return null;
    if (st.size > MAX_FLAG_BYTES) return null;

    const O_NOFOLLOW = typeof fs.constants.O_NOFOLLOW === 'number' ? fs.constants.O_NOFOLLOW : 0;
    let fd, out;
    try {
      fd = fs.openSync(p, fs.constants.O_RDONLY | O_NOFOLLOW);
      const buf = Buffer.alloc(MAX_FLAG_BYTES);
      const n = fs.readSync(fd, buf, 0, MAX_FLAG_BYTES, 0);
      out = buf.slice(0, n).toString('utf8').trim();
    } finally {
      if (fd !== undefined) fs.closeSync(fd);
    }
    return VALID_MODES.includes(out) ? out : null;
  } catch (e) {
    return null;
  }
}

let input = '';
process.stdin.on('data', chunk => { input += chunk; });
process.stdin.on('end', () => {
  try {
    const data = JSON.parse(input);
    const prompt = (data.prompt || '').trim();

    // Detect /genshijin command
    const cmdMatch = prompt.match(/^\/genshijin(?::genshijin)?(?:\s+(丁寧|通常|極限))?/);
    if (cmdMatch) {
      const newMode = cmdMatch[1] || DEFAULT_MODE;
      writeFlag(flagPath, newMode);
    }

    // Detect deactivation
    if (/原始人やめて|通常モード/.test(prompt) ||
        /\b(stop|disable|deactivate)\b.*genshijin/i.test(prompt)) {
      try { fs.unlinkSync(flagPath); } catch (e) { /* already gone */ }
    }

    // Per-turn reinforcement when active
    const activeMode = readFlag(flagPath);
    if (activeMode) {
      process.stdout.write(JSON.stringify({
        hookSpecificOutput: {
          hookEventName: 'UserPromptSubmit',
          additionalContext:
            `原始人モード有効 (${activeMode})。` +
            '敬語/クッション言葉/ぼかし/冗長助詞を削除。体言止め。助詞省略可。' +
            'コード/コミット/セキュリティ警告: 通常記述。'
        }
      }));
    }
  } catch (e) {
    // Silent fail
  }
});
