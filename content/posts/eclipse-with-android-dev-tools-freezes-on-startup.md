---
title: 'Eclipse with android dev tools freezes on startup'
date: 2014-03-14T20:58:00.001-04:00
draft: false
url: /2014/03/eclipse-with-android-dev-tools-freezes.html
---

I've just installed the eclipse+android dev tools bundle, x86\_64, version 20131030.

I've noticed that, after a few sessions, eclipse will freeze when trying to load a workspace.

The workaround is to start eclipse with the \-clean argument, which I found on [this StackOverflow page](http://stackoverflow.com/questions/12833060/eclipse-workspace-fails-loading-project-is-not-found):

```bash
$ eclipse -clean
```

That is all. I'm not investing any time learning eclipse in any detail at the moment, so I won't care why it works till it stops. This is so future-me doesn't forget what the option is called.
