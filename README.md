# whakaruru
Zero downtime reloading http server.

Expects a single `listen` server (http or other).

```js
var whakaruru = require('whakaruru');
whakaruru(function () {
  var mutunga = require('http-mutunga');
  var express = require('express');
  var app = express();

  app.get('/', function (req, res) {
    res.send('Ok');
  });

  var server = mutunga(app).listen(8080, function () {
    process.on('SIGTERM', function () {
      server.close(function () {
        process.exit(0);
      });
    });
  });
});
```

Use [http-mutunga](https://github.com/metocean/http-mutunga) for an http server that closes idle connections when `close` is called.