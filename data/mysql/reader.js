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

app.get('/measurements/quarters', function (req, res) {

    console.log("GET measurments/quarters");

    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization, X-HTTP-Method-Override");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

    // Results in average hmw per parameter per quarter = 7 parameters * 4 quarters = 28 rows
    query = 'SELECT SUM(hmw)/COUNT(*), parameter, QUARTER(datetime) FROM Measurements GROUP BY parameter, QUARTER(datetime)';

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

app.get('/measurements/months', function (req, res) {

    console.log("GET measurments/months");

    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization, X-HTTP-Method-Override");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

    // Results in average hmw per parameter per month = 7 parameters * 12 months = 84 rows
    query = 'SELECT SUM(hmw)/COUNT(*), parameter, MONTHNAME(datetime) FROM Measurements GROUP BY parameter, MONTH(datetime)';

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

app.get('/measurements/weeks', function (req, res) {

    console.log("GET measurments/weeks");

    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization, X-HTTP-Method-Override");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

    // Results in average hmw per parameter per week = 7 parameters * 52 months = 364 rows
    query = 'SELECT SUM(hmw)/COUNT(*), parameter, WEEK(datetime) FROM Measurements GROUP BY parameter, WEEK(datetime)';

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