# This script is used as an example for the blueprint blueprint-generate-wxr-from-wp-cli-commands.json that is then actually used by the script generate-wxr-from-wp-cli-commands.js.
# So this actual file is not used by the script.

## Add WooCommerce simple products.
wp wc product create --name="Simple 25%" --sku="simple-25" --regular_price="99.99" --virtual=false --downloadable=false --tax_class="25" --user="admin"
wp wc product create --name="Simple 12%" --sku="simple-12" --regular_price="158.39" --virtual=false --downloadable=false --tax_class="12" --user="admin"
wp wc product create --name="Simple 06%" --sku="simple-06" --regular_price="84.49" --virtual=false --downloadable=false --tax_class="06" --user="admin"
wp wc product create --name="Simple 00%" --sku="simple-00" --regular_price="9.99" --virtual=false --downloadable=false --tax_class="00" --user="admin"
wp wc product create --name="Simple Virtual/Downloadable 25%" --sku="simple-vir-down-25" --regular_price="99.99" --virtual=true --downloadable=true --tax_class="25" --user="admin"
wp wc product create --name="Simple Virtual/Downloadable 12%" --sku="simple-vir-down-12" --regular_price="158.39" --virtual=true --downloadable=true --tax_class="12" --user="admin"
wp wc product create --name="Simple Virtual/Downloadable 06%" --sku="simple-vir-down-06" --regular_price="84.49" --virtual=true --downloadable=true --tax_class="06" --user="admin"
wp wc product create --name="Simple Virtual/Downloadable 00%" --sku="simple-vir-down-00" --regular_price="9.99" --virtual=true --downloadable=true --tax_class="00" --user="admin"
wp wc product create --name="Simple Virtual 25%" --sku="simple-virtual-25" --regular_price="199.99" --virtual=true --downloadable=false --tax_class="25" --user="admin"
wp wc product create --name="Simple Downloadable 25%" --sku="simple-downloadable-25" --regular_price="118.89" --virtual=false --downloadable=true --tax_class="25" --user="admin"

## Add WooCommerce Variable Products
### Add Product Attribute
wp wc product_attribute create --name="Color" --user="admin"
### Add Parent Product
wp wc product create --name="Variable 25%" --sku="variable-25" --virtual=false --downloadable=false --tax_class="25" --type="variable" --attributes='[ { "id": 1, "name": "Color", "variation": true, "visible": true, "options" : ["Black", "Red", "Blue"] } ]' --user="admin"
wp wc product create --name="Variable 12%" --sku="variable-12" --virtual=false --downloadable=false --tax_class="12" --type="variable" --attributes='[ { "id": 1, "name": "Color", "variation": true, "visible": true, "options" : ["Black", "Red", "Blue"] } ]' --user="admin"
### Add variations to parent product.
wp wc product_variation create 20 --sku="variable-25-black" --regular_price="26.75" --attributes='[{"id": 1, "option": Black}]' --user="admin"
wp wc product_variation create 20 --sku="variable-25-red" --regular_price="53.27" --attributes='[{"id": 1, "option": Red}]' --user="admin"
wp wc product_variation create 20 --sku="variable-25-blue" --regular_price="96.37" --attributes='[{"id": 1, "option": Blue}]' --user="admin"
wp wc product_variation create 21 --sku="variable-12-black" --regular_price="73.21" --attributes='[{"id": 1, "option": Black}]' --user="admin"
wp wc product_variation create 21 --sku="variable-12-red" --regular_price="21.67" --attributes='[{"id": 1, "option": Red}]' --user="admin"
wp wc product_variation create 21 --sku="variable-12-blue" --regular_price="55.91" --attributes='[{"id": 1, "option": Blue}]' --user="admin"

## Add WooCommerce coupons
wp wc shop_coupon create --code="fixed-10" --amount="10" --discount_type="fixed_cart" --user="admin"
wp wc shop_coupon create --code="percent-10" --amount="10" --discount_type="percent" --user="admin"
wp wc shop_coupon create --code="percent-100" --amount="100" --discount_type="percent" --free_shipping=true --user="admin"
wp wc shop_coupon create --code="totalfreeshipping" --amount="0" --discount_type="fixed_cart" --free_shipping=true --user="admin"