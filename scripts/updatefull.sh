#!/bin/bash

message="Initiating a quick-update..."
echo "$message"
cowsay -f eyes "$message"

pushd ~/debianusbfileserver
git fetch
headsha=$(git rev-parse HEAD)
upstreamsha=$(git rev-parse @{u})
if [ "$headsha" != "$upstreamsha" ]
then
    echo "Changes detected upstream!  Updating..."
    git pull
    scripts/installfiles.sh
    installaptpackages.sh
#    quickCreateFoldersAndLinksAndRemoveOldFiles.sh
#    updateSplashscreenTextOverlay.sh
else
    echo "No changes exist upstream, no need to perform any update operations for this repo!"
fi
popd
# updateThemePrimestationOne.sh
