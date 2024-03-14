
import 'package:flutter/material.dart';


import 'package:turbopolyp/seat.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:signalr_netcore/signalr_client.dart' as signalR;
// The location of the SignalR Server.
const  serverUrl = 'https://5c86-20-16-76-181.ngrok-free.app/';

final hubConnection = signalR.HubConnectionBuilder().withUrl(serverUrl + 'seatHub').withAutomaticReconnect().build();

Future<List<Seat>> _fetchSeats() async {
  final response = await http
      .get(Uri.parse(serverUrl + 'api/seat'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response);
    return (json.decode(response.body) as List).map((i) =>
                Seat.fromJson(i)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load seats');
  }
}

void main() {

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

// Connect to the SignalR hub

  @override
  void initState() {
    super.initState();
    _startHubConnection();
    hubConnection.on("BlockSeat", _handleSeatReservation);
 
}

 void _handleSeatReservation(List<Object?>? parameters) {
    print('Handling seat reservation broadcast');
    String seatId = parameters![0] as String;


    setState(() {
      
    });
    //seats.where((element) => element.id == seatId).first;
 }

void _startHubConnection()  {
  try {
    hubConnection.start();
    print('SignalR connection started.');
  } catch (e) {
    print('Error starting SignalR connection: $e');
  }
  
}

void _reserveSeat(String seatId) async{
  try {
   await hubConnection.invoke('ReserveSeat', args: [seatId]);
    print('ReserveSeat invoked');
  } catch (e) {
    print('Error invoking reserving seat: $e');
  }
}



  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(title: const Text('Turbo Polyp Seat Reservation')),
      body: 
            FutureBuilder<List<Seat>>(
          future: _fetchSeats(),
          builder: (context, snapshot) {
           
          if (snapshot.connectionState ==  ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No seats available.'),
          );
        } else {

          

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Seat seat = snapshot.data![index];
                  return IconButton(
                    icon: const Icon(Icons.event_seat),
                    tooltip: seat.timeSlot.hour.toString(),
                    color: seat.taken ? Colors.red : Colors.green,
                    onPressed: () {
                      _reserveSeat(seat.id);
                    },
                  
                  );
                },
              );
        }
          },
        )
    );
    }
}
