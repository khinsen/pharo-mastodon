# pharo-mastodon

a [Pharo](http://pharo.org) API for [mastodon](http://joinmastodon.org)

a fork of https://github.com/estebanlm/pharo-mastodon/ with added support for lists and inspector views for [Glamorous Toolkit](http://gtoolkit.com/)

## Installation 
- You need Pharo 7.0

```Smalltalk
Metacello new 
  repository: 'github://khinsen/pharo-mastodon/src';
  baseline: 'Mastodon';
  load.
```

## Examples

### Reading your timeline.

```Smalltalk
"Create a server"
server := MdnServer url: 'https://mastodon.social'.
"Login"
login := server loginUsername: 'username@yourmail.net' password: 'shhh'.
"Read timeline 'home'"
login timelineHome next.
```

### Posting a status

```Smalltalk
"Create a server"
server := MdnServer url: 'https://mastodon.social'.
"Login"
login := server loginUsername: 'username@yourmail.net' password: 'shhh'.
"Posting a test status"
login postStatus: 'This is a test'.
```
