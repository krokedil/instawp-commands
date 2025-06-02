# Copilot Instructions for instawp-commands

Welcome to the `instawp-commands` repository! This file provides guidance for using GitHub Copilot and other AI coding assistants effectively in this project.

## Project Purpose
- This repository is for version-controlling custom InstaWP CLI commands as `.sh` files in the `commands/` directory.
- Commands are automatically synced to InstaWP using a GitHub Action.

## Best Practices
- Each command should be a standalone `.sh` file. The filename (without `.sh`) is used as the command name in InstaWP.
- Write clear comments at the top of each script to describe its purpose.
- Use POSIX-compliant shell scripting for maximum compatibility.
- When updating or adding commands, ensure the script is idempotent and safe to run multiple times.

## Documentation Resources
- **WP-CLI Command Reference:**  
  https://developer.wordpress.org/cli/commands/
- **WooCommerce CLI Command Reference:**  
  https://developer.woocommerce.com/docs/wc-cli/wc-cli-commands
- **InstaWP REST API Documentation:**  
  https://documenter.getpostman.com/view/21495096/2s8YzUyhUf

## Copilot/AI Usage Tips
- When generating or editing shell scripts, prefer clear, maintainable code and add comments for any non-obvious logic.
- If you need to automate WordPress or WooCommerce tasks, refer to the official CLI docs above for correct command usage.
- For any automation or integration with InstaWP, consult the REST API docs above for endpoints, authentication, and payload formats.
- If you are unsure about the effect of a command, test it in a safe environment before committing.

## Syncing and Command Management
- All changes to `.sh` files in `commands/` are automatically synced to InstaWP via GitHub Actions.
- The sync process will create, update, or report commands as needed. See the README for details on workflow and best practices for renaming commands.

---

For more information, see the [README.md](../README.md) and the GitHub Actions workflow in `workflows/sync-instawp-commands.yml`.
