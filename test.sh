FLX_THEME=""
function error_parameter() {
    echo "Please specific paramater at flx.config"
    echo "For more details on supported platforms, see https://www.flexurio.com"
    exit
}
function check_parameter() {
    IFS="="
    while read -r name value
    do
        if [ "$name" == "FLX_THEME" ]; then
            FLX_THEME="${value//\"/}"
            FLX_THEME="$(echo "$FLX_THEME" | awk '{print tolower($0)}')"
            echo "You using '$FLX_THEME' themes, happy coding guys, ...."
        else
            error_parameter
        fi
    done < "flx.config"
}

check_parameter
