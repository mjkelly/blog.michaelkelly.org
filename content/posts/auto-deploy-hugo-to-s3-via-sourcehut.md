---
title: Automatically deploying a Hugo static website to S3 via sourcehut
date: 2023-05-29T13:36:06-07:00
draft: false
---

This is how I'm auto-deploying a static website generated with
[Hugo](https://gohugo.io/), served from Amazon S3, with a CloudFront frontend
(for HTTPS, mostly). The code is stored in [sourcehut](https://sr.ht/), and
automatically deployed using sourcehut's [builds.sr.ht
service](https://man.sr.ht/builds.sr.ht/).

## `.build.yml`

This is what I'm using now. It includes just the build-specific bits, then
delegates to a `deploy.sh` script (described below):

```
image: alpine/edge
secrets:
  - <your ~/.aws/config secret UUID>
packages:
  - aws-cli
  - hugo
sources:
  - <https git URL of the repo you're deploying>
tasks:
  - deploy: |
      cd <name of repo>
      ./scripts/deploy.sh
```

**NOTE**: This will deploy from any branch that you push. If you want to only
deploy when you push `main`, you can add a `check-branch` action that aborts
early, [as suggested
here](https://lists.sr.ht/~sircmpwn/sr.ht-discuss/%3C3cd90a91b7ce113bb3c5f07898c77543%40hacktivista.com%3E).

To authenticate to the AWS API, we use a [build
secret](https://man.sr.ht/builds.sr.ht/#secrets) containing an entire
`~/.aws.config` file. This keeps the build file nice and simple.

You don't actually need the `sources` section when you're deploying via a
`.build.yml` -- the repo containing the `.build.yml` file is automatically
added. But it's very convenient for testing by submitting ad-hoc build files
via sourcehut's web interface.

## `scripts/deploy.sh`

I use variations of this script for different repos, so it's designed somewhat
parametrized. To adapt to a new repo you only need to adjust the variables at
the top.

Note that I use a non-default [named
profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-using-profiles)
with the `--profile` flag to `aws`. This is not necessary; it's just my
preference. You can set it to `default`.

```
#!/bin/bash
set -u
set -e
cfg=$HOME/.aws/config
profile=<your profile name>
bucket=s3://<your s3 bucket name>
dir=public
cf_id=<your cloudfront ID>
scripts=$(dirname $0)

which aws || (echo "'aws' command not found. Aborting."; exit 2)
[ -f $cfg ] || (echo "Config file $cfg does not exist. Aborting."; exit 2)

echo "Building..."
${scripts}/generate.sh

echo "Deploying..."
echo "Synchronizing directory $PWD/$dir"
aws --profile="$profile" \
  s3 sync "$dir" "$bucket" \
  --cache-control=max-age=3600
echo "Invalidating CloudFront..."
aws --profile=admin \
  cloudfront create-invalidation \
  --distribution-id "${cf_id}" \
  --paths "/*"
```

Note that you don't need to generate the static site content beforehand -- this
script runs `generate.sh` automatically. This prevents you from accidentally
deploying outdated generated content.

There's a lot of room for improvement around CloudFront here -- this script
wastefully invalidates *everything* every time you deploy. It works for me
because my sites are relatively small and infrequently updated.

## `scripts/generate.sh`

This one is simple. It generates the contents of the website, and is just
`hugo` plus whatever flags you decide to use:

```
#!/bin/bash
hugo --minify --cleanDestinationDir -d ./public || exit 1
```

By splitting everything apart like this, you can easily test and use each
component individually: You can make changes to `generate.sh` (for instance,
adding a minifying operation) and inspect the output in the `public` directory
without deploying; you can make changes to `deploy.sh` and deploy manually,
from your local machine, before trying the automated version in `.build.yml`.

## Real examples

For blog.michaelkelly.org:

* Here's the [`.build.yml`
  file](https://git.sr.ht/~mkelly/blog.michaelkelly.org/tree/main/item/.build.yml).
* Here's the [`scripts`
  directory](https://git.sr.ht/~mkelly/blog.michaelkelly.org/tree/main/item/scripts).

I hope this is useful to someone, if only to myself, in the future.
