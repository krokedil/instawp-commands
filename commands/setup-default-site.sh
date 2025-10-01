# This script is used to setup WordPress and WooCommerce with a default site configuration.

# Download WP-CLI configuration file so wp rewrite flush --hard also regenerates .htaccess file
curl -fsSL "https://raw.githubusercontent.com/krokedil/instawp-commands/refs/heads/main/assets/wp-cli-configuration/wp-cli.yml" -o "wp-cli.yml"

# Install WooCommerce development version, which have support for blueprints. (Blueprints should be available as beta from WC 9.9)
wp plugin install woocommerce --activate --force --skip-plugins --skip-themes --version=dev
wp transient delete _wc_activation_redirect --skip-plugins --skip-themes

# Set constant to allow importing WooCommerce blueprints in live mode.
wp config set ALLOW_BLUEPRINT_IMPORT_IN_LIVE_MODE true --raw --skip-plugins --skip-themes

# Download WC blueprint JSON file, import it and delete it.
curl -fsSL "https://raw.githubusercontent.com/krokedil/instawp-commands/refs/heads/main/assets/wc-blueprints/wc-blueprint-default.json" -o "wc-blueprint-imported-from-instawp-command.json"
wp wc blueprint import "wc-blueprint-imported-from-instawp-command.json" --show-messages=all --user=1 --skip-plugins --skip-themes
rm "wc-blueprint-imported-from-instawp-command.json"

# Download WXR xml, import products and coupons and delete it.
wp plugin install wordpress-importer --activate --skip-plugins --skip-themes
curl -fsSL "https://raw.githubusercontent.com/krokedil/instawp-commands/refs/heads/main/assets/wxr-exports/products-coupons-for-tests.wordpress.xml" -o "wxr-imported-from-instawp-command.xml"
wp import wxr-imported-from-instawp-command.xml --authors=skip --skip-plugins --skip-themes 
rm "wxr-imported-from-instawp-command.xml"

# Create tax settings and shipping methods.
wp wc tax create --country="SE" --rate="25" --name="VAT 25%" --class="standard" --user=1 --skip-plugins --skip-themes
wp wc tax create --country="SE" --rate="12" --name="VAT 12%" --class="reduced-rate" --user=1 --skip-plugins --skip-themes
wp wc tax create --country="SE" --rate="0" --name="VAT 0%" --class="zero-rate" --user=1 --skip-plugins --skip-themes
wp wc shipping_zone_method create 0 --enabled=true --method_id="flat_rate" --settings='{"title": "Home delivery","cost": "40,83"}' --user=1 --skip-plugins --skip-themes
wp wc shipping_zone_method create 0 --enabled=true --method_id="local_pickup" --settings='{"title": "Pickup in store","cost": "0"}' --user=1 --skip-plugins --skip-themes

# Update user meta to simplify testing when logged in as admin.
wp user meta add 1 billing_first_name "Krokedil" --skip-plugins --skip-themes
wp user meta add 1 billing_last_name "Admin Test" --skip-plugins --skip-themes
wp user meta add 1 billing_address_1 "Sveavägen 1" --skip-plugins --skip-themes
wp user meta add 1 billing_city "Stockholm" --skip-plugins --skip-themes
wp user meta add 1 billing_postcode "11157" --skip-plugins --skip-themes
wp user meta add 1 billing_phone "+463390510" --skip-plugins --skip-themes
wp user meta add 1 shipping_first_name "Krokedil" --skip-plugins --skip-themes
wp user meta add 1 shipping_last_name "Admin Test" --skip-plugins --skip-themes
wp user meta add 1 shipping_address_1 "Sveavägen 1" --skip-plugins --skip-themes
wp user meta add 1 shipping_city "Stockholm" --skip-plugins --skip-themes
wp user meta add 1 shipping_postcode "11157" --skip-plugins --skip-themes
wp user meta add 1 shipping_phone "+463390510" --skip-plugins --skip-themes

# Delete default pages, publish privacy policy and refund/returns pages and set refund/returns page as terms page.
wp post delete $(wp post list --pagename='sample-page' --format=ids) $(wp post list --post_name='hello-world' --format=ids) --force --skip-plugins --skip-themes # Delete defualt page "Sample page" and defualt post "Hello world!"
wp post update $(wp post list --pagename='privacy-policy' --format=ids) $(wp post list --pagename='refund_returns' --format=ids) --post_status=publish --skip-plugins --skip-themes
wp option update woocommerce_terms_page_id $(wp post list --pagename='refund_returns' --format=ids) --skip-plugins --skip-themes

# Create and assign menus.
wp menu create "Primary menu" --skip-plugins --skip-themes
wp menu location assign primary-menu primary --skip-plugins --skip-themes
wp menu location assign primary-menu handheld --skip-plugins --skip-themes
wp menu item add-post primary-menu $(wp option get woocommerce_shop_page_id) --skip-plugins --skip-themes
wp menu item add-post primary-menu $(wp option get woocommerce_cart_page_id) --skip-plugins --skip-themes
wp menu item add-post primary-menu $(wp option get woocommerce_checkout_page_id) --skip-plugins --skip-themes
wp menu item add-post primary-menu $(wp option get woocommerce_myaccount_page_id) --skip-plugins --skip-themes

# Configure theme and widgets.
wp widget reset --all --skip-plugins --skip-themes# Remove all default widgets to enable full width
wp theme mod set storefront_product_pagination "0" --skip-plugins --skip-themes
wp option update page_on_front $(wp option get woocommerce_shop_page_id) --skip-plugins --skip-themes
wp rewrite flush --hard --skip-plugins --skip-themes # Regenerate .htaccess file