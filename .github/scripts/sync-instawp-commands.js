const fs = require('fs');
const path = require('path');
const fetch = require('node-fetch');
const core = require('@actions/core');

const API_URL = 'https://app.instawp.io/api/v2/commands';
const API_KEY = process.env.INSTAWP_API_TOKEN;
const COMMANDS_DIR = path.join(__dirname, '../../commands');
const RESULT_FILE = path.join(process.cwd(), 'sync-results.txt');

if (!API_KEY) {
  console.error('INSTAWP_API_TOKEN is not set.');
  process.exit(1);
}

async function fetchRemoteCommands() {
  const res = await fetch(API_URL, {
    headers: {
      'Authorization': `Bearer ${API_KEY}`,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
  });
  if (!res.ok) {
    const errText = await res.text();
    throw new Error(`Failed to fetch InstaWP commands: ${res.status} ${res.statusText}\n${errText}`);
  }
  return (await res.json()).data || [];
}

async function createCommand(name, command) {
  const res = await fetch(API_URL, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${API_KEY}`,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ name, command })
  });
  if (!res.ok) {
    const errText = await res.text();
    throw new Error(`Failed to create command ${name}: ${res.status} ${res.statusText}\n${errText}`);
  }
}

async function updateCommand(id, name, command) {
  const res = await fetch(`${API_URL}/${id}`, {
    method: 'PUT',
    headers: {
      'Authorization': `Bearer ${API_KEY}`,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ name, command })
  });
  if (!res.ok) {
    const errText = await res.text();
    throw new Error(`Failed to update command ${name}: ${res.status} ${res.statusText}\n${errText}`);
  }
}

(async () => {
  const localFiles = fs.readdirSync(COMMANDS_DIR).filter(f => f.endsWith('.sh'));
  const localCommands = localFiles.map(f => ({
    name: path.basename(f, '.sh'),
    file: f,
    content: fs.readFileSync(path.join(COMMANDS_DIR, f), 'utf8').replace(/\r\n/g, '\n')
  }));

  const remoteCommands = await fetchRemoteCommands();
  const remoteMap = Object.fromEntries(remoteCommands.map(c => [c.name, c]));

  const created = [], updated = [], unchanged = [];

  for (const cmd of localCommands) {
    const remote = remoteMap[cmd.name];
    if (!remote) {
      await createCommand(cmd.name, cmd.content);
      created.push(cmd.name);
    } else if ((remote.command || '').replace(/\r\n/g, '\n') !== cmd.content) {
      await updateCommand(remote.id, cmd.name, cmd.content);
      updated.push(cmd.name);
    } else {
      unchanged.push(cmd.name);
    }
  }

  const localNames = new Set(localCommands.map(c => c.name));
  const extra = remoteCommands.filter(c => !localNames.has(c.name)).map(c => c.name);

  function formatList(title, arr, idMap) {
    if (!arr.length) return `${title}:\n- None`;
    return `${title}:\n` + arr.map(x => {
      const id = idMap && idMap[x] ? ` (id: ${idMap[x]})` : '';
      return `- ${x}${id}`;
    }).join('\n');
  }

  // Build name-to-id maps for local and extra commands
  const remoteIdMap = Object.fromEntries(remoteCommands.map(c => [c.name, c.id]));
  const localIdMap = Object.fromEntries(localCommands.map(c => [c.name, remoteIdMap[c.name] || '']));
  const extraIdMap = Object.fromEntries(extra.map(name => [name, remoteIdMap[name]]));

  const result = [
    formatList('Created', created, localIdMap),
    formatList('Updated', updated, localIdMap),
    formatList('Unchanged', unchanged, localIdMap),
    formatList('Commands that are found in InstaWP but not in this repository', extra, extraIdMap)
  ].join('\n\n');

  fs.writeFileSync(RESULT_FILE, result);
  console.log(result);

  // Add GitHub Actions annotation (async/await for summary API)
  if (process.env.GITHUB_ACTIONS) {
    await core.summary.addHeading('InstaWP Command Sync Results');
    await core.summary.addRaw('\nHere is a summary of changes that has been made to the InstaWP commands by this GitHub Action:\n\n');
    await core.summary.addRaw(`\n\
\`\`\`text\n${result}\n\`\`\`\n`);
    await core.summary.write();
  }
})().catch(e => { console.error(e); process.exit(1); });
