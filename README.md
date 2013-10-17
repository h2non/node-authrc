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

auth.get('http://myserver.org').getAuthUrl();
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
#### exists ()

Return `true` if the .authrc file was found and config exists

#### get (hostOrUrl)

Search the given string in .authrc config file

Return `HostAuth Object`

#### getHosts ()

Return an `Array` the hosts defined in the .authrc file

#### getContents ()

Return the first .authrc data contents found on the system.

The authrc file search algorithm will do what follows:

```
1. Try to find .authrc file on the current working directory
 1.1 If found, read the file, parse the content and return it
 1.2 If not found, fallback to $HOME
2. Try to find .authrc file in $HOME directory
 2.1 If found, read the file, parse the content and return it
 2.2 If not found, return `null` and exit
```

### HostAuth Object

#### getAuth ()

Returns an `Object` with the autentication credentials

#### getAuthUrl ()

Search the given string and return the full URL with the authenticacion credentials

#### exists ()

Return true if the host/url was found and credentials data exists

#### getValues ()

Return an `Object` with the found config values

#### isEncrypted ()

Return `true` if the password for the given host is encrypted

#### decrypt (key[String])

Return a `String` with the decrypted password. Key argument is required

#### encrypt (key[String], algorithm[String])

Return a `String` with the encrypted password. Key argument is required

#### host

Store the current authentication config host

## Release History

- 0.1.1 `17.10.2013`
  * API changes. Refactoring 
  * Added initial support for encrypted passwords

- 0.1.0 `16.10.2013`
  * Initial version

## TODO

- Add CLI support
- Add more test cases

## License

Copyright (c) 2013 Tomas Aparicio. 
Licensed under the MIT license.
