# Helper script to change sort order for a specific gateway
wp wc payment_gateway update {{payment_gateway_id}} --order={{order}} --user=1 --skip-themes