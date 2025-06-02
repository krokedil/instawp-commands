# Helper script to import WooCommerce blueprint

# Save the provided json as an argument as a file
cat <<'EOF' > ~/wc-blueprint-imported-from-instawp-command.json
{{wc_blueprint_json}}
EOF

# Import the WooCommerce blueprint using the wp wc command
wp wc blueprint import ~/wc-blueprint-imported-from-instawp-command.json --show-messages=all

# Remove the temporary file
rm ~/wc-blueprint-imported-from-instawp-command.json