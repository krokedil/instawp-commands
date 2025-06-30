# Helper script to import a WooCommerce blueprint that is accessible via a public URL.

# Download the provided public JSON file to a private location in the home directory
curl -fsSL "{{wc_blueprint_json_public_url}}" -o "wc-blueprint-imported-from-instawp-command.json"

# Import the WooCommerce blueprint using the wp wc command
wp wc blueprint import "wc-blueprint-imported-from-instawp-command.json" --show-messages=all --user=1

# Remove the temporary file
rm "wc-blueprint-imported-from-instawp-command.json"