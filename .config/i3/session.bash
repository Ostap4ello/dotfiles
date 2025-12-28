#
# !/bin/sh
#

function usage() {
    echo "Usage: $0 [save|restore]"
    exit 1
}

# main
if [[ "$1" == "save" ]] || [[ $1 == "restore" ]]; then
    cmd=$1
else
    usage
fi
cur=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true) | .name')
for ((i=1; i<11; i+=1)); do
    i3-resurrect $cmd -w $i
done
i3-msg workspace $cur > /dev/null

exit 0
