#!/bin/bash

repo=$1
tag=$2
releaseLink="https://api.github.com/repos/${repo}/releases/tags/$tag"

if [ "$tag" = "none" ]; then
	echo "none"
fi

if [ "$tag" = "latest" ]; then
	releaseLink="https://api.github.com/repos/${repo}/releases/latest"
fi

echo $(curl --silent ${releaseLink} | grep "browser_download_url" | grep -Eo 'https:\/\/[^\"]*\.zip')