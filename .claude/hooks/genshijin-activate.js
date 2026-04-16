#!/usr/bin/env node
// genshijin — Claude Code SessionStart activation hook
//
// Runs on every session start:
//   1. Reads active mode from flag file (~/.claude/.genshijin-mode)
//   2. Emits genshijin ruleset as SessionStart context
//
// Flag file is written by genshijin-mode-tracker.js when user runs /genshijin commands.

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

// Symlink-safe, size-capped, whitelist-validated flag file read
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

const mode = readFlag(flagPath) || DEFAULT_MODE;

// Find SKILL.md in plugin cache
let skillContent = '';
const pluginCacheBase = path.join(claudeDir, 'plugins', 'cache', 'genshijin', 'genshijin');
try {
  const versions = fs.readdirSync(pluginCacheBase);
  for (const v of versions.sort().reverse()) {
    const candidate = path.join(pluginCacheBase, v, 'skills', 'genshijin', 'SKILL.md');
    if (fs.existsSync(candidate)) {
      skillContent = fs.readFileSync(candidate, 'utf8');
      break;
    }
  }
} catch (e) { /* plugin not found — use fallback */ }

let output;
if (skillContent) {
  // Strip YAML frontmatter
  const body = skillContent.replace(/^---[\s\S]*?---\s*/, '');
  output = `原始人モード有効 — レベル: ${mode}\n\n${body}`;
} else {
  // Fallback when SKILL.md not found
  output =
    `原始人モード有効 — レベル: ${mode}\n\n` +
    '原始人のように簡潔に返答せよ。技術的中身はすべて残す。無駄だけ消す。\n\n' +
    `現在レベル: **${mode}**。切替: \`/genshijin 丁寧|通常|極限\`\n\n` +
    '毎レスポンス適用。「原始人やめて」「通常モード」で解除。\n' +
    'コード/コミット/PR: 通常どおり記述。';
}

process.stdout.write(output);
