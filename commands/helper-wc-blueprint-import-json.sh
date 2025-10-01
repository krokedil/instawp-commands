# Helper script to import a WooCommerce blueprint json that is defined as command values.

# Write the provided json string to a private location in the home directory
echo '{{wc_blueprint_json_string}}' > wc-blueprint-imported-from-instawp-command.json

# Import the WooCommerce blueprint using the wp wc command
wp wc blueprint import "wc-blueprint-imported-from-instawp-command.json" --show-messages=all --user=1 --skip-themes

# Remove the temporary file
rm "wc-blueprint-imported-from-instawp-command.json"