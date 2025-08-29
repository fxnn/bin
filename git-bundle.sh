#!/bin/sh
# stores the current git repository into a well-known local backup location
#
set -e

fatal() {
  echo "error: $1" >&2
  exit 1
}

which -s git || fatal "git not found"
which -s gpg || fatal "gpg not found"

configFile="$HOME/.config/git-bundle"
[ -f "${configFile}" ] || fatal "file ${configFile} not found"
source "${configFile}"

#bundleTargetDir=
#bundleGpgRecipient=

[ -n "${bundleTargetDir}" ] || fatal "no bundleTargetDir given"
[[ -d "${bundleTargetDir}" ]] || fatal "directory '${bundleTargetDir}' not found"
[ -n "${bundleGpgRecipient}" ] || fatal "no bundleGpgRecipient given"

gitRepoDir=$(git rev-parse --show-toplevel)
gitRepoName=$(basename "${gitRepoDir}")
bundleTargetPath="${bundleTargetDir}/${gitRepoName}.bundle.gpg"
bundleBackupPath="${bundleTargetPath}.bak"

if [ -f "${bundleTargetPath}" ]; then
  mv "${bundleTargetPath}" "${bundleBackupPath}"
fi

echo "Bundling git repository into '${bundleTargetPath}'"
echo "Encrypting for '${bundleGpgRecipient}'"
echo

git bundle create "-" --all |
  gpg --batch --verbose --recipient "${bundleGpgRecipient}" --encrypt --output "${bundleTargetPath}"

if [ -f "${bundleBackupPath}" ]; then
  rm "${bundleBackupPath}"
fi
