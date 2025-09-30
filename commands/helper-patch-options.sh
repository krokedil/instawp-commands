# Helper script to patch WordPress options as defined in command values.
# The provided options should be in JSON format, for example:
# {"option_1":{"key":"nested_option_1","key2":"nested_option_2"},"option_2":{"key":"nested_option_1","key2":"nested_option_2"}}

PATCH_OPTIONS_JSON="${PATCH_OPTIONS_JSON:-{{patch_options_json}}}"

echo "$PATCH_OPTIONS_JSON" | jq -c 'to_entries[] | {option: .key, pairs: .value | to_entries}' | while read -r option_obj; do
  option_name=$(echo "$option_obj" | jq -r '.option')
  echo "$option_obj" | jq -c '.pairs[]' | while read -r kv; do
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