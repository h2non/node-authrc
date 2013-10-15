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

Creates a new Bintray instance for working with the API

```js
var Authrc = require('authrc')

var auth = new Authrc('file/to/authrc');
```

Available config options:

* `username` [String] Bintray username
* `apikey` [String] Bintray API key token
* `organization` [String] Bintray organization or subject identifier
* `repository` [String] Repository name to use
* `debug` [Boolean] Enables de console verbose mode
* `baseUrl` [String] REST API base URL (just for testing)

You can get the current API version from the following static Object property

```js
Bintray.apiVersion // "1.0"
```

#### getRepositories()

Get a list of repos writeable by subject (personal or organizational) This resource does not require authentication

[Link to documentation](https://bintray.com/docs/api.html#_get_repositories)

#### getRepository ()

## Release History

- 0.1.0 `15.10.2013`
  * Initial version

## TODO

- Add CLI support
- Add more test cases

## License

Copyright (c) 2013 Tomas Aparicio. 
Licensed under the MIT license.
