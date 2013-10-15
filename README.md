# authrc for node [![Build Status](https://secure.travis-ci.org/h2non/node-authrc.png?branch=master)](http://travis-ci.org/h2non/node-authrc)

[authrc](http://github.com/adesisnetlife/authrc) specification implementation for Node

The implementation is based on the authrc specification version `0.1`

`Note that this is still an alpha implementation`

## Getting Started

Install the package via NPM: 

```
npm install authrc
```

Start using it!

```javascript
var AuthCredentials = require('authrc');
var auth = new AuthCredentials();

auth.getAuth('http://myserver.org');
// { username: 'john', password: 'pa$sw0rd' }

auth.getAuthUrl('https://myserver.org:8443');
// https://john:pa$sw0rd@myserver.org:8443
```

## API

## Constructor

#### new Authrc (filepath[String])

```js
var Authrc = require('authrc')

var auth = new Authrc('file/to/authrc');
```

Get the authrc version spec
```js
auth.version
```

#### getAuth (hostOrUrl)

Search the given string and returns an `Object` with the username and password for the given hostname/URL

#### getAuthUrl (hostOrUrl)

Search the given string and returns the full URL with the authenticacion credentials

#### getAuthrc ()

Returns the first .authrc data contents found on the system.

The authrc file search process algorithm will do the following:

```
1.0 Try to find on the current working directory
 1.1 If found, read the file and return the result
 1.2 If not found, fallback to $HOME
2. Try to search the file in $HOME
 2.1 If found, read it and return the content
 2.2 If not found, return `null` and exit
```

## Release History

- 0.1.0 `16.10.2013`
  * Initial version

## TODO

- Add CLI support
- Add more test cases

## License

Copyright (c) 2013 Tomas Aparicio. 
Licensed under the MIT license.
