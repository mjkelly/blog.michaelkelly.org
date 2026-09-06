#!/bin/bash
set -u
set -e
bucket=s3://blog.michaelkelly.org
dir=public
cf_id=EU89JTSK8UMKR
scripts=$(dirname $0)

which aws || (echo "'aws' command not found. Aborting."; exit 2)

echo "=== Building ==="
${scripts}/generate.sh

echo "=== Deploying ==="

echo "Special handling for index.xml (RSS feed)..."
aws s3 cp "$dir/index.xml" "$bucket/index.xml" \
  --content-type=application/rss+xml \
  --cache-control=max-age=86400

echo "Synchronizing directory $PWD/$dir to ${bucket}..."
aws s3 sync "$dir" "$bucket" \
  --cache-control=max-age=86400

if [[ -n "$cf_id" ]]; then
  echo "Invalidating CloudFront ${cf_id}..."
  aws cloudfront create-invalidation \
    --distribution-id "${cf_id}" \
    --paths "/*"
fi
