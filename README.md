# authrc for Node [![Build Status](https://secure.travis-ci.org/h2non/node-authrc.png?branch=master)](http://travis-ci.org/h2non/node-authrc)

[authrc](http://github.com/adesisnetlife/authrc) implementation for Node.js

`Note that this is still an beta implementation`

[[http://memecrunch.com/meme/8DEQ/realized-this-when-i-forgot-my-password/image.png|width=280px]]

## About

authrc is a standard configuration file that provides a centralized authentication credentials storage for network-based services and resources

For more defails, see the current [specification page](http://github.com/adesisnetlife/authrc)

Spec version supported: `0.1`

## Getting Started

Install the package via NPM: 

```
$ npm install authrc
```

For only CLI usage is recommended you install it as global package:

```
$ npm install -g authrc
```

### Examples

#### Node.js

```javascript
var Authrc = require('authrc');
var auth = new Authrc();

auth.host('http://myserver.org').auth();
// { username: 'john', password: '$up3r-p@ssw0rd' }
```

#### CLI usage

```
$ authrc 
```

## API

### Constructor

#### new Authrc([filepath])

```js
var Authrc = require('authrc')
var auth = new Authrc('file/to/.authrc'); // or without arguments for auto discovering
```

Get the authrc supported version spec
```js
Authrc.version // '0.1'
```
#### exists()

Return `true if the .authrc file was found and config exists

#### get(hostOrUrl[String])

Search the given string in .authrc config file

Return a `Host Object`

#### getHosts()

Return an `Array` the hosts defined in the .authrc file

#### getContents()

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

### Host Object

#### getAuth()

Returns an `Object` with the autentication credentials

#### getAuthUrl()

Search the given string and return the full URL with the authenticacion credentials

#### exists()

Return true if the host/url was found and credentials data exists

#### getValues()

Return an `Object` with the found config values

#### isEncrypted()

Return `true` if the password for the given host is encrypted

#### decrypt(key[String]?)

Return a `String` with the decrypted password

The `key` argument is required if the current password has no `envKey` variable defined

#### encrypt(key[String]?, algorithm[String]?)

Return a `String` with the encrypted password

The `key` argument is required if the current password has no `envKey` variable defined

#### host

Store the authentication config `Object` for the given host

## Release History

See [CHANGELOG.md](https://github.com/h2non/node-authrc/blob/master/CHANGELOG.md)

## TODO

- Add support for host based regex expressions?
- Support for create and save new config values
- Better support for password encryption
- Add CLI support
- Add E2E test suite

## License

Copyright (c) 2013 Tomas Aparicio. 
Licensed under the MIT license.
