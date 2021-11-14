# docker-image-check-update
Script to check docker image update

## Examples:
    $ ./docker-image-check-update.sh nginx:stable-alpine
    reg: docker.io org: library img: nginx tag: stable-alpine
    Fetching Docker Hub token...
    HTTP/1.1 200 OK
    content-length: 1645
    content-type: application/vnd.docker.distribution.manifest.list.v2+json
    docker-content-digest: sha256:b92d3b942c8b84da889ac3dc6e83bd20ffb8cd2d8298eba92c8b0bf88d52f03e
    docker-distribution-api-version: registry/2.0
    etag: "sha256:b92d3b942c8b84da889ac3dc6e83bd20ffb8cd2d8298eba92c8b0bf88d52f03e"
    date: Sun, 14 Nov 2021 10:27:58 GMT
    strict-transport-security: max-age=31536000
    ratelimit-limit: 100;w=21600
    ratelimit-remaining: 97;w=21600
    docker-ratelimit-source: 194.xxx.xxx.xxx


    Fetching remote digest... sha256:b92d3b942c8b84da889ac3dc6e83bd20ffb8cd2d8298eba92c8b0bf88d52f03e
    Fetching local digest...  sha256:b92d3b942c8b84da889ac3dc6e83bd20ffb8cd2d8298eba92c8b0bf88d52f03e
    nginx:stable-alpine: Already up to date. Nothing to do.

