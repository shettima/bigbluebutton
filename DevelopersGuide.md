**DRAFT**
# Introduction #
This guide is for developers who want to contribute to BigBlueButton.


# Contributing to BigBlueButton #
> If you want to contribute to BigBlueButton, please send an email to `ffdixon at gmail dot com`

# Code Convention #
  * http://java.sun.com/docs/codeconv/html/CodeConvTOC.doc.html

# How to develop with Git #
### Setting up your environment to work with GitHub ###
  * Create an account in [GitHub](http:///www.github.com).
  * [Generate ssh keys](http://help.github.com/msysgit-key-setup/) on your BigBlueButton VM where you will be doing development.
  * [Setup your username](http://help.github.com/git-email-settings/) so that commits are credited properly.

### Working with Git ###
Here we describe the workflow that you may use to develop BigBlueButton with git.

Clone BigBlueButton. This will provide you with READ-ONLY access to the repository. If you want READ-WRITE access, fork BigBlueButton into your account and checkout from there.
```
  git clone git://github.com/bigbluebutton/bigbluebutton.git
```

Once the checkout is complete, type the following
```
  git remote --verbose

  # which will show
  origin  git://github.com/bigbluebutton/bigbluebutton.git
```

What this means is that the remote repository at "git://github.com/bigbluebutton/bigbluebutton.git" is aliased as "origin"
(see http://progit.org/book/ch3-5.html)

List all the branches from the "origin"
```
  git branch

  # It will show
  * master
```

This means that there is one branch available called "master" and if you make changes, it will be applied to this branch as indicated by the "star".

Let's say your next deliverable is the record and playback feature.

Create a branch where you will be doing your work
```
  git checkout -b record-and-playback-feature

  # It will show
  Switched to a new branch "record-and-playback-feature"

  # Confirm that you are now on the record and playback brancd
  git branch

  # It should show
    master
  * record-and-playback-feature

```

You are now working on the "record-and-playback-feature" branch. While on this branch, you create new classes, delete classes, modify code and do commits.

You then decide to share your branch so that others can work with you.
```
  git push origin record-and-playback-feature
```

This will create a branch on the remote (github) "origin" repository called "record-and-playback-feature".

You then notice that someone has checked-in a fix into the master branch and you want to get it.

Update your master branch and merge the update into your "record-and-playback-feature" branch
```
  git pull origin master

  # Merger the changes from master into your branch, resolving conflicts
  git merge master
```

And you continue implementing the feature.

However, someone found a critical bug on your work on the previous release and you need to fix it right away. You commit your work on "record-and-playback" to work on a hotfix for the critical bug.

Switch to the master branch and create a hotfix branch based on master.
```
  git checkout master
  git checkout -b 0.7-hotfix

  # make the fix, test and commit  
  git commit

  # Switch to master branch
  git checkout master

  # Make sure to pull in latest changes from remote repository
  git pull origin master

  # Merge the changes, resolve all conflicts, test, and commit 
  git merge 0.7-hotfix

  # Push the hotfix to the remote repository
  git push origin master

  # Delete the hotfix branch
  git branch -d 0.7-hotfix

  # Continue working on record-and-playback
  git checkout record-and-playback-feature
```

We suggest reading the book [Pro Git](http://progit.org/book/) especially [Getting Started](http://progit.org/book/ch1-0.html), [Git Basics](http://progit.org/book/ch2-0.html), [Git Branching](http://progit.org/book/ch3-0.html), [Distributed Git](http://progit.org/book/ch5-0.html) chapters. [GitHub help](http://help.github.com/) has a lot of information too.

[Git Cheat Sheet](http://ktown.kde.org/~zrusin/git/git-cheat-sheet-medium.png)

### FAQ ###