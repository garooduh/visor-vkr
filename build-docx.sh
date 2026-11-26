#!/usr/bin/env bash
set -euo pipefail

if (( $# > 1 )) || [[ ${1:-Диплом.docx} != *.docx ]]; then
    printf 'Использование: %s [путь-к-файлу.docx]\n' "$0" >&2
    exit 2
fi

if ! command -v npx >/dev/null; then
    printf 'Для сборки нужны Node.js и npm (команда npx в PATH).\n' >&2
    exit 127
fi

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
output=${1:-"$project_dir/Диплом.docx"}
output_dir=$(cd -- "$(dirname -- "$output")" && pwd)
output_name=$(basename -- "$output")
build_dir=$(mktemp -d -- "$output_dir/.md2gost.XXXXXXXX")
trap 'rm -rf -- "$build_dir"' EXIT

cd -- "$project_dir"
npx --yes --package md2gost@1.7.0 -- md2gost 'Диплом.g.md' \
    --format docx -o "$build_dir/$output_name"

mv -fT -- "$build_dir/$output_name" "$output_dir/$output_name"
printf 'Готово. Файл сохранён в %s\n' "$output_dir/$output_name"
