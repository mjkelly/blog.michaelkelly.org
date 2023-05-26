---
title: 'Git: Picking which diffs to stage '
date: 2013-01-16T14:38:00.000-05:00
draft: false
url: /2013/01/git-picking-which-diffs-to-stage.html
---

git add typically stages files on a file-by-file basis, but you can stage single diff pieces (hunks) of a file with the \--patch (or \-p) option to git add.  

  

It will open an interactive console application to let you pick which hunks to stage.  
  
Explained in more detail here: [http://nuclearsquid.com/writings/git-add/](http://nuclearsquid.com/writings/git-add/)