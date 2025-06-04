# This script is used to setup WordPress and WooCommerce with a default site configuration.

# Install WooCommerce development version, which have support for blueprints. (Blueprints should be available as beta from WC 9.9)
wp plugin install woocommerce --activate --force --skip-plugins --skip-themes --version=dev
wp transient delete _wc_activation_redirect

# Download WC blueprint JSON file, import it and delete it.
curl -fsSL "https://raw.githubusercontent.com/krokedil/instawp-commands/refs/heads/main/assets/wc-blueprints/wc-blueprint-default.json" -o "wc-blueprint-imported-from-instawp-command.json"
wp wc blueprint import "wc-blueprint-imported-from-instawp-command.json" --show-messages=all --user=1
rm "wc-blueprint-imported-from-instawp-command.json"

# Download WXR xml, import products and coupons and delete it.
wp plugin install wordpress-importer --activate
curl -fsSL "https://raw.githubusercontent.com/krokedil/instawp-commands/refs/heads/main/assets/wxr-exports/products-coupons-for-tests.wordpress.xml" -o "wxr-imported-from-instawp-command.xml"
wp import wxr-imported-from-instawp-command.xml --authors=skip
rm "wxr-imported-from-instawp-command.xml"

# Create tax settings and shipping methods.
wp wc tax create --country="SE" --rate="25" --name="VAT 25%" --class="standard" --user=1
wp wc tax create --country="SE" --rate="12" --name="VAT 12%" --class="reduced-rate" --user=1
wp wc tax create --country="SE" --rate="0" --name="VAT 0%" --class="zero-rate" --user=1
wp wc shipping_zone_method create 0 --enabled=true --method_id="flat_rate" --settings='{"title": "Home delivery","cost": "40,83"}' --user=1