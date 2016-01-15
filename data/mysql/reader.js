var express = require('express'),
    app = express(),
    mysql = require('mysql'),
    config = require("./config.json");

connectionpool = mysql.createPool({
    host: 'localhost',
    user: config.user,
    password: config.password,
    database: 'rest_demo'
});

/*
 * Needed routes
 * /:measurement/:parameter/:detail
 * detail: tag, montag, quartal
 * /:location
 */



app.get('/:measurment', function (req, res) {
    connectionpool.getConnection(function (err, connection) {
        if (err) {
            console.error('CONNECTION error: ', err);
            res.statusCode = 503;
            res.send({
                result: 'error',
                err: err.code
            });
        } else {
            connection.query('SELECT * FROM measurments ORDER BY id DESC', function (err, rows, fields) {
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