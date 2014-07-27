# Video script

1 - Intro: about selecting in copy mode
=======================================
Actions
-------
- select a file with the mouse
- paste it in the command line

Script
------
Let's demo Tmux copycat plugin.

Tmux copycat enables you to perform regex searches and also to store those
searches for fast execution later.

This is something not possible with vanilla tmux and it can greatly reduce mouse
usage and speed up your workflow.

Let's jump to an example. We have tmux here, and I'll create some typical output
in the terminal.

Now, I want to grab that last file you see listed.
The easiest and fastest way to do it is unfortunately with a mouse.
I'll select the file.
Copy and paste it.

That, however feels wrong. I shouldn't be using mouse while in the command
line. There has to be a way to automate and speed things up with tmux.

2 - Selecting files `prefix + <C-f>`
====================================
Actions
-------
- select a file with `prefix + <C-f>`
- copy the file with `Enter`
- paste with `prefix + ]`

Script
------
Now, let's show a proper way to do it.

Tmux copycat has a predefined file search, so pressing prefix plus control-f
jumps straight to the last file.

Notice how the match is already selected.

I'll copy it with enter,
and paste it with tmux default paste "bajnding": prefix plus right angle bracket.

3 - Jumping over searches with `n` and `N`
==========================================
Actions
-------
- select a file with `prefix + <C-f>`
- another selection with `n`
- another selection with `n`
- previous match with `N`

Script
------
You can also easily jump over all the matches in the pane scrollback.

I'll enter file search with prefix control-f again.

I can move to the next match with n.

And to the previous match with uppercase n.

This jumping over the results is possible for any tmux copycat search.

4 - Selecting git status files `prefix + <C-g>`
===============================================
Actions
-------
- invoke `git status`
- the output should have: one word file name, and filename with spaces
- jump over all the results with `prefix + <C-f>`, `n` and `N`
- make sure it's shown that simple files can't be selected
- invoke `prefix + <C-g>`
- go up and down to show all the files can be selected

Script
------
File search can be really useful for selecting `git status` files. I'll invoke
`git status` to get the output.

But as you can see, file search has it's limitations.
In the example on the screen, file search didn't select `files.txt` and
`file with spaces.txt`. It just skiped those and selected the next file.

Why? Well, file search does not detect simple file names. A string has to have a
forward slash in it to be detected as a file.

To solve this, there is a git special "bajnding": prefix + control g. I'll
invoke it.

I can now smoothly jump over all the git status files, including files with
spaces and single word files.

5 - Selecting numbers `prefix + <C-d>`
======================================
Actions
-------
- create commit
- create pull request
- start assigning the pull request to me
- fetch a pull request number
- assign a pull request to me

Script
------
To show another example I'll create a somewhat realistic scenario.
I'll git add a file, make a commit and push it to a remote repo.

Next, I'll use a git alias for a program called `hub` to open a pull request
from the command line.


Good, here's the pull request url.

Now, I need to assign that pull request with the program `ghi`. For that I need
a pull request number.
This is another situation where I'd just use the mouse to select that number.

But since this is copycat demo, let's use prefix plus control d.

It searches for digits or numbers.
Copy, paste and done without reaching for the mouse.

6 - Selecting URLs `prefix + <C-u>`
===================================
Actions
-------
- select last, pull request url with `prefix + C-u`
- press n, n, then N, N
- yank it with `y`

Script
------
How about checking that pull request on github now? I need to grab a url to do that.

You might've guessed it: there's a stored search for url's. Invoke it with
prefix plus C-u and the url is selected.

7 - Plain old search with `prefix + /`
=====================================
Actions
-------
- clear screen
- enter: echo 'search me123'
- then: echo 'search me2345'
- enter search command `prefix + /`
- search for a regex `search me[[:digit:]]\\+`
- scroll accross the results
- search for a regex `search me\\d\\+`
- scroll accress the results

Script
------
Now, I want to show you how to perform a free search using regex.
In fact plain regex search is the base for all other so called "saved searches"
shown in the video so far.

I'll write a couple lines in the terminal to get some output.


Let's say we need to match 'search me' string and all the digits that come
after it. That can't be done using the tmux vanilla search, because it can do only
literal searches.

I'll invoke copycat regex search by pressing `prefix` + slash.

I get a prompt at the bottom of the screen where I can enter the search term or a regex.
I'll type 'search me', then a posix matching group for digits.

Digit can be repeated one or more times and repeating is specified by the
trailing plus.
Note, plus has to be escaped to have special meaning.
In copycat prompt, all escapes are done twice, so there are two backslashes.

I'll execute a search and as you can see, we're matching the desired string with
variable number of digits at the end. Yaay!

8 - Other use examples
======================
Actions
-------
*brew*
- brew info mobile-shell
- select project home page
- open <project home page>
*gist*
- gist -a
- some example content and a <Ctrl-d>
- highlight gist url
*rspec*
- bundle exec rspec
- have a failing spec
- highlight a failing spec file
- vim <failing spec file>

Script
------
*brew*
To conclude this screencast, I'd like to show you a couple more examples where I
find this plugin useful.

I'm using OS X, and I often check brew package manager packages.
Let's check this project called 'mobile shell'.

Hmm, that doesn't tell me much about it, but there's the project homepage in the
output.
I'll use url search to fetch and open that url.

*gist*
If you like to create gists from the command line, there's a similar use case.
I'll quickly create an example gist.

Again, I'll use url search to fetch the gist url, without using the mouse.

*rspec*
By far my most common usage of this plugin is when testing.
I'm a ruby developer and I often use rspec testing framework.
I'll run tests for this project.

Oh-oh, it seems tests fail and I have to fix them.
To open the failing test file, I'll use file search.

And now, I can open the file in vim.

That's it for this screencast. I hope you like tmux copycat and that you'll find
it useful.
