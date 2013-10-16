# authrc for node [![Build Status](https://secure.travis-ci.org/h2non/node-authrc.png?branch=master)](http://travis-ci.org/h2non/node-authrc)

[authrc](http://github.com/adesisnetlife/authrc) specification implementation for Node

The implementation is based on the authrc specification version `0.1`

`Note that this is still an alpha implementation`

## Getting Started

Install the package via NPM: 

```
npm install authrc
```

Use it:

```javascript
var Authrc = require('authrc');

var auth = new Authrc();

auth.get('http://myserver.org');

auth.getAuthUrl('https://myserver.org:8443');
// https://john:pa$sw0rd@myserver.org:8443
```

## API

### Constructor

#### new Authrc (filepath[String]?)

```js
var Authrc = require('authrc')
var auth = new Authrc('file/to/.authrc');
```

Get the authrc supported version spec
```js
Authrc.version // '0.1'
```

#### get (hostOrUrl)

Search the given string and return an `Object` with the username and password for the given hostname/URL

Returns: `HostAuth Object`

#### getAuthrc ()

Return the first .authrc data contents found on the system.

The authrc file search process algorithm will do what follows:

```
1.0 Try to find .authrc file on the current working directory
 1.1 If found, read the file and return the result
 1.2 If not found, fallback to $HOME
2. Try to find .authrc file in $HOME directory
 2.1 If found, read it and return the content
 2.2 If not found, return `null` and exit
```

### HostAuth Object

#### getAuth ()

Returns an `Object` with the autentication credentials

#### getAuthUrl ()

Search the given string and return the full URL with the authenticacion credentials

#### exists ()

Return true if the host/url was found and credentials exists

## Release History

- 0.1.0 `16.10.2013`
  * Initial version

## TODO

- Add CLI support
- Add more test cases

## License

Copyright (c) 2013 Tomas Aparicio. 
Licensed under the MIT license.
