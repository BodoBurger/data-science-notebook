# Git


## Setup and Config

### Show or change Git username or email address

```Bash
$ git config --list # repository-specific settings
$ git config --list --global # global git settings
$ git config user.name "Enrico Pallazzo"
$ git config user.email "enrico.pallazzo@lapd.com"
```
The global settings are stored in the Git config file
in the HOME directory (`~/.gitconfig`),
repository-specific settings are found at `.git/config`
in the respective repository folder.


## Branches

### Change branch without committing changes: stash and pop

Want to have a look at another branch without committing changes done so far?
Put them in a stash where they can hide until you switch back.

```Bash
$ git stash # on the original branch
$ git checkout other-branch
# do some stuff on the other branch
$ git checkout original-branch
$ git stash pop
```

More about [*git-stash*](https://git-scm.com/docs/git-stash).

### Create a local branch, push it to a remote repository and track it

```Bash
$ git checkout -b MyNewBranch # create and switch to new branch
# do some stuff
$ git push -u origin MyNewBranch
```

### Delete local branch

```Bash
$ git branch -d MyLocalBranch
```

### Create empty branch with no history

Everyone will tell you not to do this. But hey, you can do whatever you want in your own repositories, so do this:

```Bash
git switch --orphan my_new_branch

# commit some files, like a README or .gitignore

git push -u origin my_new_branch
```

- [Stackoverflow 'Create empty branch on GitHub'](https://stackoverflow.com/questions/34100048/create-empty-branch-on-github/34100189#34100189)


## Merging

### Merge master into feature branch before making a PR

```Bash
$ git checkout master
$ git pull
$ git checkout new-feature
$ git add *files-and-changes*
$ git commit -m "feature description"
$ git reset HEAD --hard # removes all uncommited files
$ rm *untracked-files*  # to prevent merge conflicts
$ git merge master
# resolve potential merge conflicts
$ git commit -m "resolved mergeconflicts | merged master"
$ git push origin new-feature
```


## Remote

https://git-scm.com/docs/git-remote

### Push local repository to existing remote

```Bash
$ git remote add origin git@github.com:USERNAME/REPOSITORY.git
$ git push --all --set-upstream origin
```

### Show or change remote

In this example we switch from HTTPS to SSH:

```Bash
$ git remote -v
> origin  https://github.com/USERNAME/REPOSITORY.git (fetch)
> origin  https://github.com/USERNAME/REPOSITORY.git (push)
$ git remote set-url origin git@github.com:USERNAME/REPOSITORY.git
$ git remote -v
> origin  git@github.com:USERNAME/REPOSITORY.git (fetch)
> origin  git@github.com:USERNAME/REPOSITORY.git (push)
```

## Submodules

https://git-scm.com/docs/git-submodule

### Add a submodule

```Bash
git submodule add git@github.com:USERNAME/REPOSITORY.git PATH/TO/SUBMODULEDIR
```

### Download files to empty submodule directory

When cloning a repository with submodules and the submodule directories are empty:

```Bash
git submodule update --init --recursive
```

### Remove a submodule (leaving no trace)

```Bash
git rm PATH/TO/SUBMODULEDIR
rm -rf .git/modules/PATH/TO/SUBMODULEDIR
git config -f .git/config --remove-section submodule.PATH/TO/SUBMODULEDIR 2> /dev/null
```


## Misc

### Remove files from the index without removing them from disc

If you forgot to add a file to `.gitignore`:

```Bash
$ git rm -rf --cached file-name
```

The file is now untracked and can be added to `.gitignore`.
Then, you can commit the deletion and the modified gitignore file.


## Useful articles / resources

### Basics

- [Git reference manual](https://git-scm.com/docs)
- [Pro Git book (2nd, 2014)](https://git-scm.com/book/en/v2)
- [Git for beginners on stackoverflow](https://stackoverflow.com/questions/315911/git-for-beginners-the-definitive-practical-guide)
- [git - the simple guide](https://rogerdudler.github.io/git-guide/)
- [The beginner's guide to contributing to a GitHub project](https://akrabat.com/the-beginners-guide-to-contributing-to-a-github-project/)
- [On undoing, fixing, or removing commits in git](http://sethrobertson.github.io/GitFixUm/fixup.html)

### Interesting discussions on Git

- [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/)
- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)
- [Code Reviews: Before You Even Run The Code](https://lornajane.net/posts/2015/code-reviews-before-you-even-run-the-code)
- [What is the benefit of gits two stage commit process](https://softwareengineering.stackexchange.com/questions/69178/what-is-the-benefit-of-gits-two-stage-commit-process-staging)
- [Why would I want to stage before committing?](https://stackoverflow.com/questions/4878358/why-would-i-want-stage-before-committing-in-git)

### GitHub

- [Keep your fork up to date with the original repo via GitHub browser interface](https://github.com/KirstieJane/STEMMRoleModels/wiki/Syncing-your-fork-to-the-original-repository-via-the-browser)
  ([stackoverflow](https://stackoverflow.com/questions/20984802/how-can-i-keep-my-fork-in-sync-without-adding-a-separate-remote/21131381#21131381))
