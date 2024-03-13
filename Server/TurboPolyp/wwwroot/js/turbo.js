"use strict";

var connection = new signalR.HubConnectionBuilder().withUrl("/seatHub").build();

connection.start().then(function () {

}).catch(function (err) {
    return console.error(err.toString());
});

connection.on("BlockSeat", function (seatId) {

    document.getElementById(seatId).classList.add("taken");
});


document.getElementById("seats").addEventListener("click", function (e) {
    if (e.target && e.target.parentNode.parentNode.matches("li")) {
        var seatId = e.target.parentNode.parentNode.id;
        connection.invoke("ReserveSeat", seatId).catch(function (err) {
            return console.error(err.toString());
        });
        alert("Seat reserved, ok let's go!");
        event.preventDefault();
    }
});

