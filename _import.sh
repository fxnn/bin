#!/bin/bash
repo_dir="${_%/*}" # needs to be first thing in the file
set -e

if [ -z "$1" ]; then
  echo "usage: $0 script_name.sh [/home/user/bin]"
  exit 1
fi
if   -n "$(git status --porcelain)" ]; then
  echo "error: non-clean git working directory"
  exit 1
fi

script_name="$1" ; shift
bin_dir="${1:-%HOME/bin}"

script_bin_path="${bin_dir}/${script_name}"
script_repo_path="${repo_dir}/${script_name}"
if ! [ -x "${script_bin_path}" ]; then
  echo "error: ${script_bin_path} not found or not executable"
  exit 1
fi
if [ -r "${script_repo_path}" ]; then
  echo "error: ${script_repo_path} already exists"
  exit 1
fi

mv "${script_bin_path}" "${script_repo_path}"
ln -s "${script_repo_path}" "${script_bin_path}"

git add "${script_repo_path}"
git commit -m "feat: add ${script_name} script"

