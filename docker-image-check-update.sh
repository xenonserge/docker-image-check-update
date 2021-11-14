!/bin/bash
# Example usage:
# ./docker-image-check-update.sh nginx:stable-alpine

if [ $# -eq 0 ]
  then
    echo "Usage: ./docker-image-check-update.sh image:tag"
    exit 1
fi


IMAGE="$1"
COMMAND="$2"

apidomain="registry-1.docker.io"

authdomsvc=`curl --head "https://${apidomain}/v2/" 2>&1 | grep realm | cut -f2- -d "=" | tr "," "?" | tr -d '"' | tr -d "\r"`

# find the number of slashes since registry name and org are not required for images in docker.io
slashes=$(echo $IMAGE | awk -F"/" '{print NF-1}')

if [ "$slashes" == "2" ]; then
reg=$(echo $IMAGE | cut -d / -f 1)
org=$(echo $IMAGE | cut -d / -f 2)
img=$(echo $IMAGE | cut -d / -f 3- | cut -d ":" -f 1)
tag=$(echo $IMAGE | cut -d / -f 3- | cut -d ":" -f 2)
elif [ "$slashes" == "1" ]; then
reg="docker.io"
org=$(echo $IMAGE | cut -d / -f 1)
img=$(echo $IMAGE | cut -d / -f 2- | cut -d ":" -f 1)
tag=$(echo $IMAGE | cut -d / -f 2- | cut -d ":" -f 2)
else
reg="docker.io"
org="library"
img=$(echo $IMAGE | cut -d ":" -f 1)
tag=$(echo $IMAGE | cut -d ":" -f 2)
fi

echo reg: $reg   org: $org   img: $img   tag: $tag

# Set the scope to look for our image
authscope="repository:${org}/${img}:pull"

echo "Fetching Docker Hub token..."
token=$(curl --silent "${authdomsvc}&scope=${authscope}&offline_token=1&client_id=shell" | jq -r '.token')
#echo $token

# Grab the docker image digest from the Docker-Content-Digest: that is in the http header
# Use “Accept: application/vnd.docker.distribution.manifest.v2+json” in order to get the version 2 schema


curl --head -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        -H "Accept: application/vnd.docker.distribution.manifest.list.v2+json" \
        -H "Authorization: Bearer $token" \
        "https://${apidomain}/v2/${org}/${img}/manifests/${tag}"

echo


echo -n "Fetching remote digest... "

digest=$(curl --silent  --head -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        -H "Accept: application/vnd.docker.distribution.manifest.list.v2+json" \
	-H "Authorization: Bearer $token" \
	"https://${apidomain}/v2/${org}/${img}/manifests/${tag}" | grep -i "Docker-Content-Digest:" | cut -f 2 -d " " | tr -d '"' | tr -d "\r" )


echo "$digest"

echo -n "Fetching local digest...  "
#local_digest=$(docker images -q --no-trunc $IMAGE)
local_digest=$(docker inspect $IMAGE --format '{{index .RepoDigests 0}}' | cut -f 2 -d "@" )

echo "$local_digest"

if [ "$digest" != "$local_digest" ] ; then
	echo "$1 :Update available. Executing update command..."
#	($COMMAND)
        echo "Mise à jour disponible pour le container $1" | /usr/bin/mail -s "Mise à jour de $1" serge@xxx.net
else
	echo "$1: Already up to date. Nothing to do."
fi
echo
