# The information of Linux system , GitHub release version
# Created: 2022-10-11
# Reference: https://github.com/AdguardTeam/AdGuardHome/blob/master/scripts/install.sh
set -e -f -u

error_exit() {
    echo "## error : " $1 1>&2
    exit 1
}

# Function is_little_endian checks if the CPU is little-endian.
# See https://serverfault.com/a/163493/267530.
is_little_endian() {
	is_little_endian_result="$(
		printf 'I'\
			| hexdump -o\
			| awk '{ print substr($2, 6, 1); exit; }'
	)"
	readonly is_little_endian_result

	[ "$is_little_endian_result" -eq '1' ]
}


# Function set_os sets the os if needed and validates the value.
set_os() {
    os="$( uname -s )"
    if [ "$os" = '' ]; then error_exit "unsupported command : uname -s"; fi
    case "$os" in
        'Darwin') os='darwin' ;;
        'FreeBSD') os='freebsd' ;;
        'Linux') os='linux' ;;
        'OpenBSD') os='openbsd' ;;
        *) error_exit "unsupported operating system: '$os'" ;;
    esac
}

# Function set_cpu sets the cpu if needed and validates the value.
set_cpu() {
	cpu="$( uname -m )"
    if [ "$cpu" = '' ]; then error_exit "unsupported command : uname -m"; fi
    case "$cpu" in
		('x86_64'|'x86-64'|'x64'|'amd64')
			cpu='amd64'
			;;
		('i386'|'i486'|'i686'|'i786'|'x86')
			cpu='386'
			;;
		('armv5l')
			cpu='armv5'
			;;
		('armv6l')
			cpu='armv6'
			;;
		('armv7l' | 'armv8l')
			cpu='armv7'
			;;
		('aarch64'|'arm64')
			cpu='arm64'
			;;
		('mips'|'mips64')
			if is_little_endian; then cpu="${cpu}le"; fi
			cpu="${cpu}_softfloat"
			;;
		(*)
			error_exit "unsupported cpu type: $cpu"
			;;
    esac
}

cpu=''
os=''
set_os
set_cpu
echo "os:$os"
echo "cpu:$cpu"

# Get GitHub release version
for soft in $@; do
    VERSION=`wget -qO- -t1 -T2 "https://api.github.com/repos/$soft/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
    if [ '' = "$VERSION" ]; then 
        VERSION=`wget -qO- -t1 -T2 "https://api.github.com/repos/$soft/releases/latest" | grep "tag_name" | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
    fi

    if [ '' = "$VERSION" ]; then 
        error_exit "$soft cannot be found in GitHub Release"
    fi
    echo "$soft:$os-$cpu-$VERSION"
done