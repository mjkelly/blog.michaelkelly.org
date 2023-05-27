---
title: Mirroring sourcehut repositories to GitHub
date: 2023-05-27T14:30:00.000-04:00
draft: false
---

In the spirit of not using the dominant free service for *everything*, I've
been using [sourcehut](https://sr.ht/) more instead of GitHub. I pay them a
small fee each month in exchange for a valuable service, which seems perfectly
fair to me.

(The contents of this blog are now in sourcehut! See: 
<https://git.sr.ht/~mkelly/blog.michaelkelly.org>.)

However, since GitHub is still free I don't see any harm in continuing to store
some repos there. I'd like to commit to sourcehut, and have those changes
automatically mirrored to GitHub's copy the repo.

Fortunately sourcehut has a very straightforward
[builds](https://man.sr.ht/builds.sr.ht/) service that makes this very easy.
You can trigger a build when you commit to a repo by adding a `.build.yml` to
the root of the repo.

After some Googling on advanced (to me) `git push` syntax, I settled on an
easily-parametrized `.build.yml` that mirrors to github. I found it useful and
I hope you do too.

This is based in part on [~rolandog](https://git.sr.ht/~rolandog/)'s example [.build.yml
here](https://git.sr.ht/~rolandog/pam-u2f-totp-config/tree/main/item/.build.yml)!

```
image: alpine/edge
secrets:
  - <uuid-of-github-push-key>
environment:
  REPO: <repo-name>
  GH_USER: <github-username>
tasks:
  - write-ssh-config: |
      cat <<_FILE_ >> ~/.ssh/config
      Host github.com
        IdentityFile ~/.ssh/id_rsa
        IdentitiesOnly yes
        BatchMode yes
        StrictHostKeyChecking no
      _FILE_
  - push-to-github: |
      cd ~/"${REPO}"
      # remove remotes/origin/HEAD so we don't push it
      git remote set-head origin -d
      git remote add github "git@github.com:${GH_USER}/${REPO}.git"
      git push --prune github '+refs/remotes/origin/*:refs/heads/*' '+refs/tags/*:refs/tags/*'
```

The 3 things you have to modify are:
- `<uuid-of-github-push-key>`: UUID of your github push key, stored as a [build
  secret](https://man.sr.ht/builds.sr.ht/#secrets).
- `<repo-name>`: the name of your repo (without your username). I assume this
  is the same in both sourcehut and GitHub.
- `<github-username>`: your GitHub username, used to construct the full name of
  the GitHub repo to mirror to.



I use this in my [config](https://git.sr.ht/~mkelly/config) repo: you can see
the `.build.yml` in use
[here](https://git.sr.ht/~mkelly/config/tree/master/item/.build.yml).
