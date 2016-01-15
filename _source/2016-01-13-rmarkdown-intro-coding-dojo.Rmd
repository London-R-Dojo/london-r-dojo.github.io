---
layout: post
title:  "Creation of a website for the Coding Dojo"
categories: [jekyll]
tags: [servr]
---

It's been a while that people come to the Rcoding Dojo and create rmarkdown which are stocked on the coding dojo repository.

Recently, the trio jekyll + Github + rmarkdown for blogging had became really popular, with web sites like [Yihui repo](https://github.com/yihui/knitr-jekyll), [Brendan Rocks](http://brendanrocks.com/blogging-with-rmarkdown-knitr-jekyll/) or [data-labborer.eu](data-laborer.eu) (that one is mine). In my opinion for three reasons: it's free, allow dynamic content and when set up, it's as simple as creating a rmarkdown.

All in all, these elements gave us the idea to create a website for our monthly r session, the coding dojo.

As far as I am aware of, this is the __first r-based website multi-authors and totally open source__. True story.

## Process
 
 As not everybody have the time to learn jekyll or YAML, we made a process which allow participants of the coding dojo not to worry about the publishing details.
 
Basically, there is three levels of authority on this web sites:

 - The participants of the coding dojo.
      + They create rmarkdown files and push them on github.
 - The people which have jekyll on their laptop.
      + The role is to generate the static website when there is a new rmarkdown file.  
 - The admin of the github account.
      + Our fantastic host, Sergiusz, which orchestre the github account.

How does it work? 

 1. Participants of the coding dojo create a rmarkdown file and push it on github, on the `_source` folder. It is best if the script respect the criteria define in the next chapter.

 2. Anybody with jekyll on his laptop could clone the repository, generate the updated static website and push the result on github.
 
 3. Sergiusz manage the conflict which could appear and accept or reject or stop the conflicts of the update.

## Include a post in the coding dojo web site

The process to include a post in the coding dojo website is very simple:

- Create a rmarkdown file.
- Define the header.
- push it on the github repo in the _source folder.

### Create a rmarkdown file

You know what to do. In the other case, come to the next coding dojo session.

Little specificity, it is better to make the script self compilable.

If you include data, the data should be pushed as well and with a relative path. Ex: read.csv(".data/my_csv.csv")

It is possible to include already knited rmarkdown script(in html format).
In that case, the header of the rmarkdown file should be copied in the html file and the html should be put in _posts instead of _source.

### Define the header

The classic header for a rmarkdown script looks like that:

    ---
    title: "mytitle" 
    author: "YCR" 
    date: "13 January 2016" 
    output: html_document 
    ---


With this header, rmarkdown create a html file with a title, author and date elements.

Now, for the creation of a post, the header should looks like that:

    ---
    layout: post
    title:  "my title"
    categories: [jekyll, cat2, cat3, etc.]
    tags: [servr, tag2, tag3, etc.]
    ---

The only essential element here is `layout: post`, which indicate to jekyll that this is a post. This allow jekyll to add the classic layouts (comments, links to the homepage, etc.)

Title, tags and categories are only nice to have (and are self-explainable).

In the case of an already knitted script, copy the header in the html script.

### Push the file to github

When the rmarkdown file is ready and set, clone/synchronised the coding dojo repository, and push your .rmd script on the folder `_source`. ( [here](https://github.com/London-R-Dojo/Dojo-repo))

If you push an html file or a .md file, push it on the `_posts` folder.

Then post a message on the meetup page to allow people with jekyll to generate the static website.

## People with jekyll on their laptop

Anybody can generate a static website with jekyll, but the set up may be complex when you are alone and in a rush.

To generate the static website, the process is the following:

 - Install jekyll on your laptop.
 - Install r and rstudio on your laptop.
 - Install the `servr` package on your r session.
 - Clone the github repository of the coding dojo, [here](https://github.com/London-R-Dojo/Dojo-repo).
 - On the root folder of the web site, run `servr::jekyll()`.
 - QA the site in `_site`.
 - Push and synchronise the github repo.

For more information, the r function jekyll is better explained by [Yihui Xie](http://yihui.name/knitr-jekyll/2014/09/jekyll-with-knitr.html) and the jekyll process and customisation by the [jekyll documentation](http://jekyllrb.com/). 

## Github administrator

I give here an insight on the role of the github account administrator, if you want to reproduce the same thing in your own dojo.

Basically, the job is to create a github repository, set the github account to make it a [project page](https://help.github.com/articles/user-organization-and-project-pages/) and manage the conflicts.

## Conclusion

To be written with experience.
