var csv = require("fast-csv");
var fs = require('fs');
var mysql = require('mysql');
var config = require("./config.json");

var amountOfRowsToInsert = 0;
var measurements = {};

var connection = mysql.createConnection({
    host: 'localhost',
    user: config.user,
    password: config.password,
    database: 'airquality'
});

connection.connect(function (err) {
    if (err) {
        console.error('error connecting: ' + err.stack);
    } else {
        console.log('connected as id ' + connection.threadId);
    }
});

connection.query('DROP TABLE IF EXISTS Measurements');
connection.query('CREATE TABLE Measurements(' +
    'id MEDIUMINT PRIMARY KEY AUTO_INCREMENT,' +
    'location VARCHAR(127) NOT NULL,' +
    'latitude FLOAT NOT NULL ,' +
    'longitude FLOAT NOT NULL,' +
    'parameter VARCHAR(127) NOT NULL,' +
    'datetime DATETIME NOT NULL,' +
    'hmw FLOAT NOT NULL' +
    ')', function (err, rows) {
        readFile();
    });

var readFile = function () {
    console.log("Starting to read file...");
    csv.fromPath("../dataset.csv", {
        headers: true,
        delimiter: ";"
    }).on("data", function (data) {

        //Invalid data let us skipping the current row
        if (data["Zeitpunkt"].indexOf(" ") == -1) {
            return;
        } else {
            measurements[amountOfRowsToInsert] = data;
            amountOfRowsToInsert++;
            console.log("File row read #" + amountOfRowsToInsert);
        }

    }).on("end", function () {
        writeDB(0);
        console.log("File saved to database...");
    });
};

var writeDB = function (index) {

    var data = measurements[index];

    //Need to convert the timestamp for mysql into the format YYYY-MM-DD HH:MM:SS
    var datetime = data["Zeitpunkt"].split(" ");
    var date = datetime[0].split(".");
    var time = datetime[1].split(":");
    var datetime = date[2] + "-" + date[1] + "-" + date[0] + " " + time[0] + ":" + time[1] + ":00"

    var post = {
        location: data["Messort"],
        latitude: data["LATITUDE"].replace(",", "."),
        longitude: data["LONGITUDE"].replace(",", "."),
        parameter: data["Parameter"],
        datetime: datetime,
        hmw: data["HMW"].replace(",", ".")
    };

    var insert = connection.query('INSERT INTO Measurements SET ?', post, function (err, result) {
        if (err) {
            throw err;
        }
        else {

            if (index === amountOfRowsToInsert) {
                connection.end();
            } else {
                writeDB(++index);
            }

            console.log("Inserted row #" + index);
        }
    });

};
