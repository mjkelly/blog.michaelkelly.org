---
title: 'Using Hugo Without a Theme'
date: 2019-05-05T23:42:00.000-04:00
draft: false
url: /2019/05/using-hugo-without-theme.html
---

[Hugo](https://gohugo.io/) is a very powerful site generator, and includes plenty of features for large static sites. Most tutorials focus on how to quickly get a nice-looking site using a theme.  
  
What if you're coming from the other direction, however? Maybe you want to extend an existing single-page site to multiple pages without totally structuring it (or copying and pasting the common bits). Or maybe you're perfectly happy to write your own CSS. Hugo is still a great tool!  

###   

### Just show me an example!

You don't have to read any of this post if you don't want to -- just see the [hugo-skel repository in Github](https://github.com/mjkelly/hugo-skel).  

###   

### The explanation

(This isn't meant to be a standalone post -- It's helpful to work through the [Hugo quickstart](https://gohugo.io/getting-started/quick-start/) guide, at least, to get familiar with Hugo's terminology and basic structure.)  
  
The gist of it is, look at the [base template lookup order](https://gohugo.io/templates/base/#base-template-lookup-order), which shows that you can use the layouts directory instead of the themes directory to find templates.  
  

*   All you _really_ need is layouts/\_default/baseof.html -- that's the base template for all other types of pages. This is where you write "<!DOCTYPE html><html lang="en"><head> \[...\]".
*   To define actual pages, put them in content just as you would if you were using a theme. Here's a minimal example:  
    \---  
    title: "Main page"  
    \---  
    <p>This is the main page content.</p>
*   Put your static files (CSS, Javascript) in the static directory.
*   You'll get warnings if you don't define at least a few other specific templates:

*   Hugo will give warnings on site generation unless you have (assuming we're putting everything in the layouts directory): layouts/index.html and layouts/\_default/single.html. To (mostly) avoid duplicating template logic, you can have them reference your baseof.html: Where you'll want the main content of your pages, define a "main" block in baseof.html like this:  
    {{ block "main" . }}{{ .Content }}{{ end}}
*   Now, you can write a minimal template in layouts/index.html -- layouts/\_default/single.html: Put the following in both files to override the "main" block from baseof.html with an empty string:  
    {{ block "main" . }}{{ end}}

*   By default Hugo also wants to generate "taxonomy" pages, which list groups of pages of the same type. To turn this off, add the following to your config.toml:  
    disableKinds = \["taxonomy", "taxonomyTerm"\]

  

That's it! Now you've got all the power of Hugo's template engine, without anything controlling your formatting.

  
  
All of this, along with an example of using Hugo's menu system, is in the [hugo-skel](https://github.com/mjkelly/hugo-skel) git repo. I tested this out with Hugo 0.54.0.