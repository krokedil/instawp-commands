# Helper script to patch WordPress options as defined in command values.
# The provided options should be in JSON format, for example:
# {"option_1":{"key":"nested_option_1","key2":"nested_option_2"},"option_2":{"key":"nested_option_1","key2":"nested_option_2"}}

echo '{{patch_options_json}}' | jq -c 'to_entries[]' | while read -r option_entry; do
  option_name=$(echo "$option_entry" | jq -r '.key')
  echo "$option_entry" | jq -c '.value | to_entries[]' | while read -r kv; do
    key=$(echo "$kv" | jq -r '.key')
    value=$(echo "$kv" | jq -r '.value')
    echo "Running: wp option patch insert $option_name $key $value"
    wp option patch insert "$option_name" "$key" "$value"
  done
done
# The above will run, for example:
# wp option patch insert option_1 key nested_option_1
# wp option patch insert option_1 key2 nested_option_2
# wp option patch insert option_2 key nested_option_1
# wp option patch insert option_2 key2 nested_option_2