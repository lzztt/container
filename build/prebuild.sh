set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

sudo apt update && sudo apt -y full-upgrade && sudo apt autoremove

sudo apt -y install `awk '/^[^#]/{print $1}' $DIR/deb.conf`
