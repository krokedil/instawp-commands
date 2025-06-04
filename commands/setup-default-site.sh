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
wp wc shipping_zone_method create 0 --enabled=true --method_id="local_pickup" --settings='{"title": "Pickup in store","cost": "0"}' --user=1

# Update user meta to simplify testing when logged in as admin.
wp user meta add 1 billing_first_name "Krokedil"
wp user meta add 1 billing_last_name "Admin Test"
wp user meta add 1 billing_address_1 "Sveavägen 1"
wp user meta add 1 billing_city "Stockholm"
wp user meta add 1 billing_postcode "11157"
wp user meta add 1 billing_phone "+463390510"
wp user meta add 1 shipping_first_name "Krokedil"
wp user meta add 1 shipping_last_name "Admin Test"
wp user meta add 1 shipping_address_1 "Sveavägen 1"
wp user meta add 1 shipping_city "Stockholm"
wp user meta add 1 shipping_postcode "11157"
wp user meta add 1 shipping_phone "+463390510"

# Delete default pages, publish privacy policy and refund/returns pages and set refund/returns page as terms page.
wp post delete $(wp post list --pagename='sample-page' --format=ids) $(wp post list --post_name='hello-world' --format=ids) --force # Delete defualt page "Sample page" and defualt post "Hello world!"
wp post update $(wp post list --pagename='privacy-policy' --format=ids) $(wp post list --pagename='refund_returns' --format=ids) --post_status=publish
wp option update woocommerce_terms_page_id $(wp post list --pagename='refund_returns' --format=ids)

# Create and assign menus.
wp menu create "Primary menu"
wp menu location assign primary-menu primary
wp menu location assign primary-menu handheld
wp menu item add-post primary-menu $(wp option get woocommerce_shop_page_id)
wp menu item add-post primary-menu $(wp option get woocommerce_cart_page_id)
wp menu item add-post primary-menu $(wp option get woocommerce_checkout_page_id)
wp menu item add-post primary-menu $(wp option get woocommerce_myaccount_page_id)

# Configure theme and widgets.
wp widget reset --all # Remove all default widgets to enable full width
wp theme mod set storefront_product_pagination "0"
wp option update page_on_front $(wp option get woocommerce_shop_page_id)
wp rewrite structure "/%postname%/" --hard