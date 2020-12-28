# gh-docker-registry

Docker Registry for GitHub action cache

## Reference

From [docker-distribution](https://github.com/docker/distribution)
From [docker-distribution-library-image](https://github.com/docker/distribution-library-image)

## Changes

- Add user `runner:github` as `1001:121` to allow mount volume in `github-runer` host with `docker container` on `github-runner`
