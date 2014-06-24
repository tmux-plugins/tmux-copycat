# Video script

1 - Intro: about selecting in copy mode
=======================================
Actions
-------
- select a file with the mouse
- paste it in the command line

Script
------
Let's demo a tmux copycat plugin.

I have tmux here and I want to grab that file you see at the top.
The easiest and fastest way to do it is unfortunately with mouse.

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
Now, there is a way to do this with tmux copycat plugin.

It has a predefined file search so pressing prefix plus control-f jumps
straight to the last file.

Notice how the match is already selected.
I'll copy it with enter,
and paste it with tmux default paste binding: prefix plus right angle bracket.

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

I'll enter file search with prefix control-f again. I can move to the next
match with n, and to the previous match with uppercase n.

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
File search can be really useful for selecting `git status` files.

But as you can see, file search has it's limitations. It does not detect
simple file names. A string has to have a forward slash in it to be detected as
a file.

Tmux copycat has a git special binding for this.
Prefix + control g after git status command, guarantees you'll be able to
smoothly jump over all the files.
That includes files with spaces and single word files.

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
Let's make a commit and open a pull request now.

I have git aliases for a program called hub set up.

And here's the pull request url.

Now, I'll assign the pull request to me. For that I need a pull request number.
I could just type it, but since this is copycat demo, let's use prefix plus
control d (d as digits).

Copy, paste and done.

6 - Selecting URLs `prefix + <C-u>`
===================================
Actions
-------
- select last, pull request url with `prefix + C-u`
- press n, n, then N, N
- yank it with `y`

Script
------
I wanna go check out the pull request on github now. I need to grab a url for
that.
You might have guessed it: there's a stored search for that prefix plus C-u.

I need to yank the url to the system clipboard so it's accessible outside tmux.
For that, I'm using tmux yank so, I'll just press y and the selection is copied
to the clipboard.

7 - Plain old search with `prefix + /`
=====================================
Actions
-------
- enter search command `prefix + /`
- search for a regex `tm..`

Script
------
For the end, I just want to show how to manually enter a search regex, instead
of just using predefined ones.

I'll search for `tm..`, dots beeing the whildcards.
And, as usual I get the highlighted results I can jump over.

That's it, I hope you like tmux copycat!
