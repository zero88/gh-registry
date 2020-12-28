# gh-docker-registry

Docker Registry for GitHub action cache

## Reference

- From [docker-distribution](https://github.com/docker/distribution)
- From [docker-distribution-library-image](https://github.com/docker/distribution-library-image)

## Changes

- Add user `runner:github` as `1001:121` to allow mount volume in `github-runer` host with `docker container` on `github-runner`

## Usage

```yaml
  build:
    runs-on: ubuntu-latest
    services:
      registry:
        image: zero88/gh-registry:latest
        ports:
          - 5000:5000
        options: >-
          -v /home/runner:/var/lib/registry
          --name registry

    steps:
      - uses: actions/checkout@v2
      - name: Cache Docker layers
        uses: actions/cache@v2
        with:
          path: /home/runner/docker
          key: ${{ runner.os }}-docker-${{ github.sha }}
          restore-keys: |
            ${{ runner.os }}-docker-

      - name: Validate cache
        run: |
          docker buildx imagetools inspect localhost:5000/test:buildcache
      
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      - name: Docker build
        uses: docker/build-push-action@v2
        with:
          context: .
          file: Dockerfile
          platforms: linux/amd64,linux/arm64,linux/arm/v7
          cache-from: type=registry,ref=localhost:5000/test:buildcache
          cache-to: type=registry,ref=localhost:5000/test:buildcache,mode=max
          tags: images/test:1.0.0

      - name: Cleanup Docker build cache if any
        run: |
          docker buildx imagetools inspect localhost:5000/test:buildcache
          echo "======================================================"
          docker buildx prune --filter until=72h --keep-storage 5GB -f

```
