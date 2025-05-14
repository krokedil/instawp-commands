# instawp-commands

This repository is used for keeping InstaWP CLI commands in version control and automatically syncing them to InstaWP using a GitHub Action.

## Purpose
- Maintain all your custom InstaWP CLI commands as version-controlled `.sh` files in the `commands/` directory.
- Ensure that any changes to these files are automatically reflected in your InstaWP account.
- Get visibility into which commands are created, updated, unchanged, or exist in InstaWP but not in this repository.

## How Sync Works
- On every commit to the `main` branch (or when run manually), a GitHub Action will:
  - Compare all `.sh` files in the `commands/` directory to the commands in InstaWP.
  - **Create** new commands in InstaWP for any new `.sh` files.
  - **Update** commands in InstaWP if the file content has changed.
  - **Leave unchanged** commands that are identical.
  - **Report** any commands in InstaWP that are not present in this repository.
- The sync summary is shown as an annotation in the GitHub Actions run.

## Adding a New Command
1. Add a new `.sh` file to the `commands/` directory. The filename (without `.sh`) will be used as the command name in InstaWP.
2. Commit and push your changes to the `main` branch.
3. The GitHub Action will create the new command in InstaWP automatically.

## Updating an Existing Command
1. Edit the corresponding `.sh` file in the `commands/` directory.
2. Commit and push your changes to the `main` branch.
3. The GitHub Action will update the command in InstaWP if the content has changed.

## Info About Extra Commands
- After each sync, the GitHub Action will list any commands that exist in InstaWP but are not present in this repository.
- Review these and, if needed, add them to the repo or remove them from InstaWP manually.

## Renaming Commands
- **Important:** The command name in InstaWP is determined by the filename (without `.sh`).
- If you want to rename a command **without changing its ID** (recommended):
  1. First, update the command name directly in InstaWP to the new name you want.
  2. Then, rename the corresponding `.sh` file in the `commands/` directory to match the new name.
  3. Commit and push the change.
  4. The GitHub Action will sync the content and keep the command ID unchanged.
- If you rename the file first, a new command will be created in InstaWP and the old one will remain (with its original ID). This is not recommended, as the command ID is used when executing commands.
- If you want to remove the old command, delete it manually from InstaWP.

## Use commands in GitHub Actions

You can trigger InstaWP commands from other GitHub Actions or CI/CD workflows by using the **ID** of the command. The command ID is shown in the GitHub Actions summary annotation after each sync.

To execute a command via the InstaWP API, use the command's ID as described in the InstaWP API documentation:

- [InstaWP API: Run a Command](https://documenter.getpostman.com/view/21495096/2s8YzUyhUf#73577fec-13ac-4696-a0a9-b3d34d9a9353)

This allows you to automate workflows that interact with your InstaWP sites using the exact commands you keep in version control.

---

For more details, see the GitHub Actions workflow and the sync script in `.github/scripts/sync-instawp-commands.js`.
