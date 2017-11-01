# Changelog

### master

### v3.0.0, Nov 01, 2017
- if installed use `gawk` instead of `awk` (@metcalfc)
- add stored search for matching git SHAs (@jbnicolai)
- move documentation from github wiki to `docs/` folder
- support for tmux 2.4+, not compatible with tmux 2.3 and earlier (@thalesmello)

### v2.1.0, Jan 01, 2015
- combine send-keys calls to reduce flickering (@toupeira)
- add `file:///` prefix for local file url's (@vellvisher)
- add `git://` type url

### v2.0.0, Oct 16, 2014
- add tmux options for default searches
- use `session_id` instead of `session_name` in the copycat file name (solution
  provided by @toupeira)
- use `grep -E` and remove eval (@toupeira)

### v1.1.0, Sep 29, 2014
- add IP address search
- enhance url search with git and ftp urls

### v1.0.0, Aug 31, 2014
- simplify file search stored regex
- match files starting with dot
- improve README - add more relevant related plugins
- do not use `copycat_clear_search` method when in copycat mode. It was causing
  mysterious issues for some users.
- update `README.md` - warning about a breaking mapping
- remove rails request stored search `C-r`

### v0.1.0, Aug 02, 2014
- remove note about git history issue
- url saved search includes `#` character
- improve stored search handling
- update README and document addding custom stored searches

### v0.0.7, Jul 31, 2014
- add customization section to the readme (@soli)
- remove screencast from the project. The video is too bit and plugin download
  is slow because of that. The video is moved to the separate `screencast`
  branch.
- run test suite on 2 vagrant VMs: ubuntu and centos

### v0.0.6, Jul 28, 2014
- update video script
- update readme and invite for code contributions
- update dockerfile with it's purpose
- add test suite `README` file
- add screencast original document to git
- add video directory `README` file
- update readme to reflect github organization change
- add a screencast link to the readme

### v0.0.5, Jul 24, 2014
- improve stored file matching search
- fix wrong result highlighting for lines that have \r, \n chars
- another improvement to file matching search: changed regex strategy to be
  "inclusive"
- add test suite
- update readme to show how test suite is started

### v0.0.4, Jul 9, 2014
- bugfix for incorrect result highlighting
- optimize and improve the function that centers the result vertically on the
  screen
- fix OS X awk bug: awk variable content can't start with `=` char
- fix a bug with wrong result highlighting caused by using `printf`
- fix a bug with wrong result highlighting caused by a bug in OSX `grep`
- improve URL matching regex. Matches don't include quotes anymore.

### v0.0.3, Jun 29, 2014
- add notifications about the first and last match
- improve "jump correction" handling by fetching the precise window height
- improve result vertical centering & fix a related bug

### v0.0.2, Jun 26, 2014
- search results are always at the bottom of the page. If possible center the
  result, or provide maximum possible padding.
- refactoring in `copycat_jump.sh` - extract 2 constants to file global variables
- improve file matching regex. `master...origin/master` is not detected as a
  string.

### v0.0.1, Jun 25, 2014
- first version, plugin working
