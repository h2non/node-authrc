# authrc for Node 

[![Build Status](https://secure.travis-ci.org/h2non/node-authrc.png?branch=master)](http://travis-ci.org/h2non/node-authrc)
[![Dependency Status](https://gemnasium.com/h2non/node-authrc.png)](https://gemnasium.com/h2non/node-authrc)

[authrc](http://github.com/adesisnetlife/authrc) implementation for Node.js

`Note that this is still a beta implementation`

## About

`.authrc` aims to be a standard community well supported which provides a generic and centralized configuration file for authentication credentials management and storage that can be used by applications or services for network-based resources

For more defails, see the current [specification page](http://github.com/adesisnetlife/authrc)

Version implemented: `0.1-beta`

## Getting Started

Install the package via NPM: 

```
$ npm install authrc --save
```

For CLI usage is recommended you install it as global package:

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

## Command-line interface

```
$ authrc --help

  Usage: authrc [options] [command]

  Commands:

    create [options]       
      Create new .authrc file
    add [options]          
      Add new host to an existant .authrc file
    remove [options] <host> 
      Remove a host from .authrc
    update [options] <host> 
      Update a host from .authrc

  Options:

    -h, --help     output usage information
    -V, --version  output the version number

  Usage examples:

    $ authrc create --path /home/user/
    $ authrc add --path ./.authrc
    $ authrc remove my.host.org
    $ authrc update my.host.org

```

## Programmatic API

### Constructor

#### new Authrc([filepath])

Throws an exception if the `.authrc` is a bad formed JSON

```js
var Authrc = require('authrc');
var auth = new Authrc('file/to/.authrc');
```

Get the authrc supported version spec

```js
Authrc.version // '0.1'
```

#### exists()

Return `true` if the `.authrc` file was found and it's not empty

#### host(url[String])

Search a host by the given string in .authrc config file

Return [Host Object](#Host)

#### find(url[String])

Alias to `host()`

#### getHosts()

Return an `Array` the existant hosts in the current `.authrc` file

#### getData()

Return the first .authrc data contents found on the system.

The file discovery search algorithm will do what follows:

```
Try to find .authrc file on the current working directory
  If it exists, read and parse it
  If it doesn’t exist, fallback to $HOME
Try to find .authrc file in $HOME directory
  If it exists, read and parse it
  If it doesn’t exist, finish the process
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
- Add CLI full support
- Add E2E test suite

## License

Copyright (c) 2013 Tomas Aparicio. 
Licensed under the MIT license.
