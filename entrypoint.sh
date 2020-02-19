#!/bin/bash

BASE="${INPUT_PATH:-.}"
POLICY="${INPUT_POLICY:-.policy}"
FILES=( ${INPUT_FILES} )
MATCHES=( ${INPUT_MATCHES} )

match() {
  local arg=${1}
  if [[ ${#MATCHES[@]} == 0 ]]; then
    return 0
  fi
  local match
  for match in ${MATCHES[@]}
  do
    if [[ ${arg} == ${match} ]]; then
      return 0
    fi
  done
  return 1
}

run_stein() {
  local file
  local -a files

  for file in "${FILES[@]}"
  do
    if ! match ${file}; then
      echo "[DEBUG] ${file}: against the matches condition, so skip it" >&2
      continue
    fi

    files+=( "${file}" )
  done

  stein apply \
    -policy "${POLICY}" \
    "${files[@]}" 2>&1 # use stdout to make tee command capture the output

  return ${?}
}

main() {
  local -i status

  run_stein "$@" | tee -a result
  status=${?}

  result="$(cat result)"
  # https://github.community/t5/GitHub-Actions/set-output-Truncates-Multiline-Strings/td-p/37870
  echo "::set-output name=result::${result//$'\n'/'%0A'}"

  return ${status}
}

set -o pipefail

main "$@"
exit $?
