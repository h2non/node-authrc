# authrc for node 

[![Build Status](https://secure.travis-ci.org/h2non/node-authrc.png?branch=master)](http://travis-ci.org/h2non/node-authrc)
[![Dependency Status](https://gemnasium.com/h2non/node-authrc.png)](https://gemnasium.com/h2non/node-authrc)

[authrc](http://github.com/adesisnetlife/authrc) implementation for [node.js](http://nodejs.org)

`Still a beta version`

## About

`.authrc`provides a generic and centralized configuration file for authentication credentials management and storage, that can be used by any application or service for network-based resources. It aims to be a standard adopted by the community

For more details, see the current `authrc` [specification](http://github.com/adesisnetlife/authrc)

`authrc` spec version supported: `0.1`

## Getting Started

Install the package via NPM: 

```
$ npm install authrc --save
```

For CLI usage is recommended you install it as global package:

```
$ npm install -g authrc
```

## Features

- Simple and elegant JavaScript API
- Transparent password decryption
- Compare existent hosts to prevent redundancy
- Full featured command-line interface
- File change watcher with automatically data reload
- Heavily tested with full coverage

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
    auth [options] <host>  
      Get the authencation credentials from the given host
    list [options]         
      List the current existent hosts in .authrc
    copy [options] <host> <newhost> 
      Copy existent host credentials to another host
    decrypt [options] <password> 
      Utility for easy password decryption
    encrypt [options] <password> 
      Utility for easy password encryption

  Options:

    -h, --help            output usage information
    -V, --version         output the version number
    -I, --implementation  Current authrc implementation language
                          Useful for multiple installed implementations

  Usage examples:

    $ authrc create --path /home/user/
    $ authrc add
    $ authrc list
    $ authrc remove my.host.org
    $ authrc update my.host.org
    $ authrc auth my.host.org
    $ authrc copy my.host.org net.host.net
    $ authrc decrypt e9b90003128c4215ba005a08615fa64f
    $ authrc encrypt p@sw0rd

  Command specific help:

    $ authrc <command> --help

```

## Programmatic API

```javascript
var Authrc = require('authrc');
var auth = new Authrc('path/to/.authrc'); 
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

For more usage examples, see the [tests](https://github.com/h2non/node-authrc/tree/master/test)

### Constructor

#### new Authrc([filepath])

**Throws an exception** if `.authrc` is a bad formed JSON

`filepath` argument to the `.authrc` file or directory is optional

```js
var Authrc = require('authrc');
var auth = new Authrc('path/to/.authrc');
```

Get the current `authrc` supported spec version implementation

```js
Authrc.version // '0.1'
```

Discover the `.authrc` file path on the system. Return `null` if not found.

```js
Authrc.discover(); // '/home/user/.authrc'
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

#### Authrc.find(string, [filepath])

Static method for find hosts, for a simplified and better API approach

```js
require('authrc').find('my.server.org').username();
```

You can use this method using also the `get()` alias method

#### exists()

Return `true` if the `.authrc` file was found and it is not empty

#### host(string)

Find a host searching by the given `string` in the current `.authrc` file

Chainable. Return [Host Object](#host-object)

```javascript
auth.host('http://my.server.org').exists();
```

#### find(string)

Alias to `host()`

#### add(host, authObject)

Add new host to the current `.authrc` config

Chainable. Return [Auth Object](#new-authrcfilepath)

```javascript
auth.add('my.server.org', {
  username: 'lisa',
  password: 'my_p@s$w0rd'
})
```

#### create(data, callback)

Create a new `.authrc` in disk on the current path, optionally passing the data `object`.
Useful for creating new files.

Chainable. Return [Auth Object](#new-authrcfilepath)

```javascript
var auth = new Authrc('new/path');

var myConfig = {
  'my.server.org': {
    username: 'lisa',
    password: 'my_p@s$w0rd'
  },
  'another.server.org': {
    username: 'john',
    password: '@an0th3r_p@s$w0rd'
  }
};

if (!auth.exists()) {
   auth.create(config, function (err) {
    if (err) {
      console.error('Error creating the file:', err);
      return;
    }
    console.log('File created successfully!'); 
   });
}
```

#### remove([host])

Removes a host from the config. You need to call `save()` method to apply changes in disk

You can pass an argument if you are using the method from `Authrc` object.
Both `string` and `Host object` types are supported

Chainable. Return [Auth Object](#new-authrcfilepath)

```javascript
auth.remove('my.server.org').hostExists('my.server.org'); // false
```

```javascript
var host = auth.host('my.server.org');
auth.remove(host).hostExists('my.server.org'); // false
```

```javascript
var host = auth.host('my.server.org');
host.remove();
```

#### save(callback, [data])

Save the current config in disk. 
This is a asynchronous task, so you need to pass a callback function to handle it.

Optionally you can pass the whole `data` object that overrides the currently cached (but be aware about how to use it in order to prevent unexpected behavior or object schema errors)

Chainable. Return [Auth Object](#new-authrcfilepath)

```javascript
auth.save(function (err, data) {
  if (err) {
    console.error('Cannot save the data:', err);
    return;
  } 
  console.log('Config data saved succesfully');
});
```

#### read()

Update the cached config data from disk file.

By default you dont need to use it because a file watcher is listening on background for file changes. If happends, it will reload automatically the config from disk.

Chainable. Return [Auth Object](#new-authrcfilepath)

#### update()

Alias to `read()`

#### hosts()

Return an `Array` with the existent hosts in the current `.authrc` file

#### getData()

Return the `.authrc` object found on the system. 

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

#### file

This property `file` specifies the current used `.authrc` file path


### Host Object

#### auth([username], [password])

Return the authentication config `object`

If arguments passed, updates the authentication data object

```javascript
auth.host('http://my.server.org').auth(); 
// { username: 'john', password: '$up3r-p@ssw0rd' }
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

```javascript
auth.host('http://my.server.org').auth('michael', {
  value: '41b717a64c6b5753ed5928fd8a53149a7632e4ed1d207c91',
  cipher: 'idea'
});
```

#### authUrl()

Return the search URI/URL `string` with authentication credentials

```javascript 
auth.host('my.server.org').auth(); 
// http://jogn:password@my.server.org
```

#### exists()

Return `true` if the host was found and auth credentials data exists

```javascript
auth.host('my.server.org').exists(); // true
```

#### user(string)

Return the username `string` for the current host

```javascript
auth.host('my.server.org').username(); // 'john'
```

```
auth.host('my.server.org').username('michael');
```

#### username(string)

Alias to `user()`

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

Return the full authentication plain `object` 

```javascript
auth.host('my.server.org').get(); 
// { username: 'john', password: 'myP@ssw0rd' }
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

#### copy(string)

Copy the current `host` credentials to another `host`

```javascript
auth.host('my.server.org').copy('new.server.org');
auth.host('new.server.org').exists(); // true
```

#### remove()

Remove the current host from config

Return a [Host Object](#host-object)

```javascript
auth.host('my.server.org').remove();
auth.save();
```

#### valid()

Return `true` if the current host authentication credentials are valid

#### cipher([string])

Return the password cipher algorithm `string` if the password was encrypted

If argument is passed, it defines the cipher algorithm to use for the current password.
The `string` must be one of the listed [supported ciphers](#supported-cipher-algorithms) algorithms

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

Chainable. Return a [Host Object](#host-object)

The `key` argument is required if the current password has no `envKey` variable defined

**Throws an exception** if the arguments are not valid, the decryption key is incorrect 
or an error success during the decryption process.

```javascript
var host = auth.host('encrypted.server.org');

if (!host.isEncrypted()) {
  host.encrypt('€ncrypt_p@s$w0rd', 'blowfish');
  console.log('Encrypted:', host.password());
}
```

`Host Object` has the following inherited methods (which are also available from [Auth Object](#new-authrcfilepath)):

- [add()](##addhost-authobject)
- [save()](#savecallback-data)
- [create()](#createdata-callback)
- [read()](#read)
- [update()](#update) 

### Supported cipher algorithms

- AES128 (default)
- AES256
- Camellia128
- Camellia256
- Blowfish
- CAST
- IDEA
- SEED

For more information, see the `authrc` [specification](https://github.com/adesisnetlife/authrc)

## Release History

See [CHANGELOG](https://github.com/h2non/node-authrc/blob/master/CHANGELOG.md)

## TODO

- Checking duplicated hosts before create
- Add more destructive and smoke tests
- Add more regex tests
- Add E2E test suite

## License

Copyright (c) 2013 Tomas Aparicio. 
Licensed under the MIT license.
