#!/bin/bash

set -ex

cd "${HOME}"

DPKGS_LIST=('coreutils' 'curl' 'tar')
GO_DL_VERS='1.15'
GO_DL_PATH='https://dl.google.com/go/'
GO_DL_FILE="go${GO_DL_VERS}.linux-amd64.tar.gz"
GO_DL_HASH="${GO_DL_FILE}.sha256"
GO_LC_ROOT="${HOME}/opt/golang"
GO_LC_PATH="${GO_LC_ROOT}/.go-v${GO_DL_VERS}"
GO_LC_BINS="${GO_LC_ROOT}/bin"
GO_LC_WORK="${HOME}/projects/golang"
GO_LC_PRFL="${HOME}/.profile"

for s in $(which -a zsh 2> /dev/null); do
	if [[ "${s}" == "${SHELL}" ]]; then
		GO_LC_PRFL="${HOME}/.zprofile"
	fi
done

sudo apt install --yes ${DPKGS_LIST[*]}

if [[ -d "${GO_LC_PATH}" ]]; then
	rm -fr "${GO_LC_PATH}"
fi

mkdir -p "${GO_LC_PATH}"
cd "${GO_LC_ROOT}"

curl -O "${GO_DL_PATH}${GO_DL_FILE}"
curl -O "${GO_DL_PATH}${GO_DL_HASH}"

printf '%s  %s' "$(cat "${GO_DL_HASH}")" "${GO_DL_FILE}" | sha256sum --check -

tar xzf "${GO_DL_FILE}" -C "${GO_LC_PATH}" --strip-components=1

rm "${GO_DL_HASH}" "${GO_DL_FILE}"

if [[ -d "${GO_LC_BINS}" ]]; then
	rm -fr "${GO_LC_BINS}"
fi

ln -s "${GO_LC_PATH}/bin" "${GO_LC_BINS}"

printf 'Installed Golang binary distribution at "%s": %s\n' "${GO_LC_BINS}" "$("${GO_LC_ROOT}/bin/go" version)"

printf '\n' >> "${GO_LC_PRFL}"
printf '# set golang env variables $GO(ROOT|PATH) for binary root and workspace path\n' >> "${GO_LC_PRFL}"
printf 'export GOROOT="%s"\n' "${GO_LC_PATH}" >> "${GO_LC_PRFL}"
printf 'export GOPATH="%s"\n' "${GO_LC_WORK}" >> "${GO_LC_PRFL}"
printf '\n' >> "${GO_LC_PRFL}"
printf '# add golang install bin path and workspace bin path to env $PATH variable\n' >> "${GO_LC_PRFL}"
printf 'PATH="%s:%s:%s/bin"\n' "${PATH}" "${GO_LC_BINS}" "${GO_LC_WORK}" >> "${GO_LC_PRFL}"
printf '\n' >> "${GO_LC_PRFL}"

mkdir -p "${GO_LC_WORK}/src"
mkdir -p "${GO_LC_WORK}/bin"

. "${GO_LC_PRFL}"

cd && GO111MODULE=on go get github.com/mikefarah/yq/v3
