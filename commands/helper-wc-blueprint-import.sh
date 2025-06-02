# Helper script to import WooCommerce blueprint

# Download the provided public JSON file to a private location in the home directory
TMP_JSON="~/wc-blueprint-imported-from-instawp-command.json"
curl -fsSL "{{wc_blueprint_json_public_url}}" -o "$TMP_JSON"

# Import the WooCommerce blueprint using the wp wc command
wp wc blueprint import "$TMP_JSON" --show-messages=all

# Remove the temporary file
rm "$TMP_JSON"