var express = require('express'),
    app = express(),
    mysql = require('mysql'),
    config = require("./config.json");

connectionpool = mysql.createPool({
    host: 'localhost',
    user: config.user,
    password: config.password,
    database: 'airquality'
});

app.get('/parameters', function(req, res){
    var query = "SELECT parameter FROM Measurements GROUP BY parameter";

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

app.get('/locations', function(req, res){
    var query = "SELECT location FROM Measurements GROUP BY location;";

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

app.post('/', function (req, res) {

    console.log(req.body, req.params);
    return;

    var query = '';

    // Results in average hmw per parameter per month = 7 parameters * 12 months = 84 rows
    if(req.params.resolution === "m"){
        query = 'SELECT SUM(hmw)/COUNT(*), parameter, MONTHNAME(datetime) FROM Measurements GROUP BY parameter, MONTH(datetime)';
    }
    // Results in average hmw per parameter per week = 7 parameters * 52 months = 364 rows
    // Submit week?
    else if(req.params.resolution === "w"){
        query = 'SELECT SUM(hmw)/COUNT(*), parameter, WEEK(datetime) FROM Measurements GROUP BY parameter, WEEK(datetime)';
    }
    // Results in average hmw per parameter per quarter = 7 parameters * 4 quarters = 28 rows
    else if(req.params.resolution === "q"){
        query = 'SELECT SUM(hmw)/COUNT(*), parameter, QUARTER(datetime) FROM Measurements GROUP BY parameter, QUARTER(datetime)';
    }
    // Results in average hmw per parameter per location per quarter = 4 * 7 * 12 = 336
    else if(req.params.location === true){
        query = 'SELECT SUM(hmw)/COUNT(*), location, parameter, QUARTER(datetime) FROM Measurements GROUP BY parameter, QUARTER(datetime), location';
    }

    if(!query){
        console.error('MYSQL error: empty query!');
        res.statusCode = 500;
        res.json({
            result: 'error',
            err: 'Empty query'
        });
        return;
    }



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