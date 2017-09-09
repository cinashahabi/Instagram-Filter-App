var express = require('express');
var bodyParser = require('body-parser')
var app = express();

app.set('port', process.env.PORT || 8000)

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.listen(app.get('port'), function() {
	console.log('Server started on localhost:' + app.get('port') + '; Press Ctrl-C to terminate.');
})

app.get('/', function(req, res) {
	res.json({ code: req.query.code });
})
