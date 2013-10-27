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

```
var Authrc = require('authrc');
var auth = new Authrc('file/to/.authrc');
var host;

if (auth.exists()) {
  host = auth.find('my.server.org');

  if (host.exists()) {
    if (host.encrypted() && !host.canDecrypt()) {
      console.log(host.username(), host.decrypt('p@s$w0rD'));
    } else {
      console.log(host.username(), host.password());
    }
  } else {
    console.log('Host do not exists!');
  }
}
```

For more real use examples, see [test/](https://github.com/h2non/node-authrc/tree/master/test)

### Constructor

#### new Authrc([filepath])

**Throws an exception** if `.authrc` is a bad formed JSON

`filepath` argument is optional

```js
var Authrc = require('authrc');
var auth = new Authrc('file/to/.authrc');
```

Get the authrc supported version spec

```js
Authrc.version // '0.1'
```

The `.authrc` file discovery search algorithm will do what follows:

```
Try to find .authrc file on the current working directory
  If it exists, read and parse it
  If it doesn’t exist, fallback to $HOME
Try to find .authrc file in $HOME directory
  If it exists, read and parse it
  If it doesn’t exist, finish the process
```

#### exists()

Return `true` if the `.authrc` file was found and it's not empty

#### host(string)

Find a host searching by the given `string` in the current `.authrc` file

```javascript')
auth.host('http://my.server.org').exists();
```

Return [Host Object](#Host)

#### find(string)

Alias to `host()`

#### hosts()

Return an `Array` the existent hosts in the current `.authrc` file

#### getData()

Return the `.authrc` Object found on the system. 

```javascript
if (auth.exists()) {
  console.log(auth.getData());
}
```

#### exists()

Return `true` if file exists and has data

```javascript
var auth = new Authrc('non/existent/path');
auth.exists(); // false
```

#### hostExists(string)

Return `true` if the given host exists

```javascript
auth.hostExists('http://my.server.org/resource'); // true
```

#### unwatch()

Disable `.authrc` file watch for changes

This is useful when different applications makes concurrent changes over the file. If you disabled no data will be updated after file changes in your current instance

#### isGlobalFile()

Return `true` if the current `.authrc` file is located globally (in `$HOME/%USERPROFILE%` directories)


### Host Object

#### auth([string|object])

Returns the authentication config `object`

If argument passed, updates the authentication data Object

```javascript
auth.host('http://my.server.org').auth(); // { username: 'john', password: '$up3r-p@ssw0rd' }
```

```javascript
auth.host('http://my.server.org').auth({
  username: 'michael',
  password: {
    value: '41b717a64c6b5753ed5928fd8a53149a7632e4ed1d207c91',
    cipher: 'idea'
  }
});
```

#### authUrl()

Return the search URI/URL `string` with authentication credentials

```javascript 
auth.host('my.server.org').auth(); // http://jogn:password@my.server.org
```

#### exists()

Return `true` if the host was found and auth credentials data exists

```javascript
auth.host('my.server.org').exists(); // true
```

#### username(string)

Return the username `string` for the current host

```javascript
auth.host('my.server.org').username(); // 'john'
```

```
auth.host('my.server.org').username('michael');
```

#### password([string|object])

Return the password `string` for the current host

If argument passed, updates the password with the given value

```javascript
auth.host('my.server.org').password(); // 'my_p@s$w0rd'
```

```
auth.host('my.server.org').password('my_n€w_p@s$w0rd');
```

#### get()

Return the fill authentication `object` 

```javascript
auth.host('my.server.org').get(); // { username: 'john', password: 'myP@ssw0rd' }
```

#### set(object)

Set the full authentication `object` for the current host.

The argument `object` must have both `username` and `password` properties

```javascript
auth.host('my.server.org').set({
  username: 'michael',
  password: 'myPassword'
});
```

#### valid()

Return `true` if the current host authentication credentials are valid

#### cipher()

Return the password cipher algorithm `string` if the password was encrypted

#### encrypted()

Return `true` if the password for the given host is encrypted

#### canDecrypt()

Return `true` if the password is encrypted and the decryption key is available (via environment variable)

```javascript
var host = auth.host('encrypted.server.org');

if (host.canDecrypt()) {
  // note that you can decrypt without passing the key argument
  console.log('Password:', host.decrypt()); 
}
```

#### decrypt([key], [cipher])

Return a `String` with the decrypted password

**Throws an exception** if the arguments are not valid or the decryption key is incorrect 
or a error success during the decryption process.

The `key` argument is required if the current password has no `envKey` variable defined

```javascript
var host = auth.host('encrypted.server.org');

if (!host.isEncrypted()) {
  console.log('Decrypted:', host.decrypt('d€crypt_p@s$w0rd', 'blowfish'););
}
```

#### encrypt([key], [cipher])

Return a `Host Object`

The `key` argument is required if the current password has no `envKey` variable defined

**Throws an exception** if the arguments are not valid or the decryption key is incorrect 
or a error success during the decryption process.

```javascript
var host = auth.host('encrypted.server.org');

if (!host.isEncrypted()) {
  host.encrypt('€ncrypt_p@s$w0rd', 'blowfish');
  console.log('Encrypted:', host.password());
}
```

### Supported cipher algorithms

- AES128
- AES192 (default)
- AES256
- Blowfish
- Camellia128
- Camellia256
- CAST
- IDEA
- SEED

For more information, see the [specification page](https://github.com/adesisnetlife/authrc)

## Release History

See [CHANGELOG.md](https://github.com/h2non/node-authrc/blob/master/CHANGELOG.md)

## TODO

- Add support for host based regex expressions?
- Add CLI full support
- Add E2E test suite

## License

Copyright (c) 2013 Tomas Aparicio. 
Licensed under the MIT license.
