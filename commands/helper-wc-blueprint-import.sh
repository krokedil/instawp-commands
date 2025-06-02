# Helper script to import WooCommerce blueprint

# Download the provided public JSON file to a private location in the home directory
curl -fsSL "{{wc_blueprint_json_public_url}}" -o "$HOME/wc-blueprint-imported-from-instawp-command.json"

# Import the WooCommerce blueprint using the wp wc command
wp wc blueprint import "$HOME/wc-blueprint-imported-from-instawp-command.json" --show-messages=all

# Remove the temporary file
rm "$HOME/wc-blueprint-imported-from-instawp-command.json"