#!/bin/sh
set -x
set -eu
cd -- "$(dirname "$0")/.."

go vet ./...
GOOS=js GOARCH=wasm go vet ./...

go install honnef.co/go/tools/cmd/staticcheck@v0.4.7
staticcheck ./...
GOOS=js GOARCH=wasm staticcheck ./...

govulncheck() {
	tmpf=$(mktemp)
	if ! command govulncheck "$@" >"$tmpf" 2>&1; then
		cat "$tmpf"
	fi
}
go install golang.org/x/vuln/cmd/govulncheck@v1.1.1
govulncheck ./...
GOOS=js GOARCH=wasm govulncheck ./...

(
  cd ./internal/examples
  go vet ./...
  staticcheck ./...
  govulncheck ./...
)
(
  cd ./internal/thirdparty
  go vet ./...
  staticcheck ./...
  govulncheck ./...
)
