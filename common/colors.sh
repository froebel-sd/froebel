if [ "$COLORS" == "off" ]; then
    c_red=''
    c_green=''
    c_yellow=''
    c_blue=''
    c_reset=''
else
    c_red="\e[0;31m"
    c_green="\e[0;32m"
    c_yellow="\e[0;33m"
    c_blue="\e[0;34m"
    c_reset="\e[0m"
fi