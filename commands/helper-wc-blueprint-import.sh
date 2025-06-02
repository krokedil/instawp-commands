# Helper script to import WooCommerce blueprint

# Save the provided json as an argument as a file
echo "{{wc_blueprint_json}}" > ~/wc-blueprint-imported-from-instawp-command.json

# Import the WooCommerce blueprint using the wp wc command
wp wc blueprint import ~/wc-blueprint-imported-from-instawp-command.json --show-messages=all

# Remove the temporary file
rm ~/wc-blueprint-imported-from-instawp-command.json