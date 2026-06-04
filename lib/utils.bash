#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/j178/prek"
TOOL_NAME="prek"
TOOL_TEST="prek --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

get_platform() {
	local os arch libc
	os=$(uname -s)
	arch=$(uname -m)

	case "$os" in
	Darwin)
		case "$arch" in
		x86_64) printf "%s\n" "x86_64-apple-darwin" ;;
		arm64 | aarch64) printf "%s\n" "aarch64-apple-darwin" ;;
		*) fail "Unsupported macOS architecture: $arch" ;;
		esac
		;;
	Linux)
		libc="gnu"
		if command -v ldd >/dev/null 2>&1 && ldd --version 2>&1 | grep -qi '^musl'; then
			libc="musl"
		elif ls /lib/ld-musl-*.so.1 /usr/lib/ld-musl-*.so.1 >/dev/null 2>&1; then
			libc="musl"
		fi

		case "$arch" in
		x86_64) printf "%s\n" "x86_64-unknown-linux-$libc" ;;
		aarch64 | arm64) printf "%s\n" "aarch64-unknown-linux-$libc" ;;
		*) fail "Unsupported Linux architecture: $arch" ;;
		esac
		;;
	*)
		fail "Unsupported operating system: $os"
		;;
	esac
}

download_release() {
	local version filename url platform
	version="$1"
	filename="$2"
	platform="$(get_platform)"

	url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-${platform}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version for $platform..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	if ! (
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	); then
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	fi
}
