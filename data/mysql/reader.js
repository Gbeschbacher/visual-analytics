var express = require('express');
var mysql = require('mysql');
var config = require("./config.json");
var app = express();

connectionpool = mysql.createPool({
    host: 'localhost',
    user: config.user,
    password: config.password,
    database: 'airquality'
});

app.get('/parameters', function (req, res) {

    console.log("GET parameters");

    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization, X-HTTP-Method-Override");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

    connectionpool.getConnection(function (err, connection) {
        if (err) {
            console.error('CONNECTION error: ', err);
            res.statusCode = 503;
            res.json({
                result: 'error',
                err: err.code
            });
        } else {
            connection.query("SELECT parameter FROM Measurements GROUP BY parameter", function (err, rows, fields) {
                if (err) {
                    console.error(err);
                    res.statusCode = 500;
                    res.send({
                        result: 'error',
                        err: err.code
                    });
                }

                res.send({
                    result: 'success',
                    err: '',
                    fields: fields,
                    json: rows,
                    length: rows.length
                });
                connection.release();
            });
        }
    });
});

app.get('/locations', function (req, res) {

    console.log("GET locations");

    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization, X-HTTP-Method-Override");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

    connectionpool.getConnection(function (err, connection) {
        if (err) {
            console.error('CONNECTION error: ', err);
            res.statusCode = 503;
            res.json({
                result: 'error',
                err: err.code
            });
        } else {
            connection.query("SELECT location FROM Measurements GROUP BY location", function (err, rows, fields) {
                if (err) {
                    console.error(err);
                    res.statusCode = 500;
                    res.send({
                        result: 'error',
                        err: err.code
                    });
                }

                res.send({
                    result: 'success',
                    err: '',
                    fields: fields,
                    json: rows,
                    length: rows.length
                });

                connection.release();
            });
        }
    });
});

app.get('/measurements', function (req, res) {

    console.log("GET measurments per parameter (containing location + value)");

    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization, X-HTTP-Method-Override");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

    // Results in average hmw per parameter per quarter = 7 parameters * 4 quarters = 28 rows
    query = 'SELECT AVG(hmw) AS value, parameter, location, latitude, longitude FROM Measurements GROUP BY parameter, location';

    connectionpool.getConnection(function (err, connection) {
        if (err) {
            console.error('CONNECTION error: ', err);
            res.statusCode = 503;
            res.json({
                result: 'error',
                err: err.code
            });
        } else {
            connection.query(query, function (err, rows, fields) {
                if (err) {
                    console.error(err);
                    res.statusCode = 500;
                    res.json({
                        result: 'error',
                        err: err.code
                    });
                }

                rows = convert(rows);

                res.json({
                    result: 'success',
                    err: '',
                    fields: fields,
                    json: rows,
                    length: rows.length
                });
                connection.release();
            });
        }
    });
});

var convert = function (rows) {
    var tmp = {};
    rows.forEach(function (element, index, array) {
        var idx = element.parameter.indexOf(" ");
        var parameter = element.parameter.substring(0, idx).toLowerCase();

        if (!tmp.hasOwnProperty(parameter)) {
            tmp[parameter] = []
        }
        tmp[parameter].push({
            value: element.value,
            // changed because writer has a bug
            location: element.location,
            latitude: element.longitude,
            longitude: element.latitude
        })
    });

    var array = [];
    for (var property in tmp) {
        if (tmp.hasOwnProperty(property)) {
            var obj = {
                name: property,
                values: []
            };

            tmp[property].forEach(function (index, element, array) {
                obj.values.push(index);
            });

            array.push(obj);
        }
    }

    return array;
};

app.get('/measurements/months', function (req, res) {

    console.log("GET measurments/months");

    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization, X-HTTP-Method-Override");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

    // Results in average hmw per parameter per month = 7 parameters * 12 months = 84 rows
    query = 'SELECT AVG(hmw) as value, parameter, DATE_FORMAT(datetime, "%Y-%m-%h") as month FROM Measurements GROUP BY parameter, MONTH(datetime)';

    connectionpool.getConnection(function (err, connection) {
        if (err) {
            console.error('CONNECTION error: ', err);
            res.statusCode = 503;
            res.json({
                result: 'error',
                err: err.code
            });
        } else {
            connection.query(query, function (err, rows, fields) {
                if (err) {
                    console.error(err);
                    res.statusCode = 500;
                    res.json({
                        result: 'error',
                        err: err.code
                    });
                }

                console.log(rows);

                res.json({
                    result: 'success',
                    err: '',
                    fields: fields,
                    json: rows,
                    length: rows.length
                });
                connection.release();
            });
        }
    });
});

app.listen(3000);
console.log("Server started...");