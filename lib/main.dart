import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testa/jsonfile.dart';
import 'dart:convert';
import 'moviepage.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Movie Adda",
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieHub movieHub;



  @override
  void initState() {
    super.initState();
    fetchData();
  }
  StreamSubscription<DataConnectionStatus> listener;

  fetchData() async {
    DataConnectionStatus status = await checkInternet();
    if (status == DataConnectionStatus.connected) {
      var url =
          "http://api.themoviedb.org/3/movie/popular?api_key=802b2c4b88ea1183e50e6b285a27696e";
      var res = await http.get(url);
      var decodedValue = jsonDecode(res.body);
      movieHub = MovieHub.fromJson(decodedValue);
      print(movieHub);
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Something went wrong."),
          content: Text("Check your internet connection."),
        ),
      );
    }
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  checkInternet() async {
    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });

    return await DataConnectionChecker().connectionStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Adda"),
      ),
      body: MovieHub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              //crossAxisCount: 2,
              children: movieHub.results
                  .map(
                    (Results resu) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoviePage(
                                overview: resu.overview,
                                originalLanguage: resu.originalLanguage,
                                adult: resu.adult,
                                popularity: resu.popularity,
                                voteAverage: resu.voteAverage,
                                movieName: resu.originalTitle,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2.0,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Hero(
                                    tag: resu.originalTitle,
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://www.slashfilm.com/wp/wp-content/images/bloodshot-clips.jpg"),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                      resu.originalTitle,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Rating : ${resu.voteAverage}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
