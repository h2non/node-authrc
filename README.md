# authrc for node [![Build Status](https://secure.travis-ci.org/h2non/authrc-node.png?branch=master)](http://travis-ci.org/h2non/authrc-node)

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

`TODO`

## Release History

- 0.1.0 `15.10.2013`
  * Initial version

## TODO

- Add CLI support
- Add more test cases

## License

Copyright (c) 2013 Tomas Aparicio. 
Licensed under the MIT license.
