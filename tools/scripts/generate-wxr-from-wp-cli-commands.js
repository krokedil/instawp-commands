// This script spins up a WordPress Playground site using @wp-playground/cli and applies the blueprint-generate-wxr-from-wp-cli-commands.json blueprint.
// Usage: node generate-wxr-from-wp-cli-commands.js

const { execSync } = require('child_process');
const path = require('path');

const playgroundCli = 'npx @wp-playground/cli';
const blueprintPath = path.join(__dirname, 'assets/blueprint-generate-wxr-from-wp-cli-commands.json');
const projectPath = path.join(__dirname, '../../');

try {
  console.log('Starting WordPress Playground with blueprint and mounting wxr-exports...');
  // Run Playground CLI with the blueprint and mount wxr-exports to wp-content/uploads
  execSync(
    // If you want to test the blueprint instead of just running it, you can uncomment the next line and comment the one after it:
    `${playgroundCli} server --blueprint ${blueprintPath} --mount ${projectPath}:/instawp-commands --login`,
    //`${playgroundCli} run-blueprint --blueprint ${blueprintPath} --mount ${wxrExportsPath}:/wordpress/wp-content/uploads/wxr-exports`,
    { stdio: 'inherit' }
  );
} catch (error) {
  console.error('Failed to start Playground or apply blueprint:', error.message);
  process.exit(1);
}
