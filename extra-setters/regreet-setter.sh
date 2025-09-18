flavor="green"
if [ ! -z "${CATPPUCCIN_FLAVOR}" ]; then
    flavor=$CATPPUCCIN_FLAVOR
fi
if command -v regreet > /dev/null 2>&1
then
    pkexec sed -i "/theme_name =/c\\theme_name = \"catppuccin-mocha-${flavor}-standard+default\"" /etc/greetd/regreet.toml
fi