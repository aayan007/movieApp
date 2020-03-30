import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {
  final String movieName;
  final String voteAverage;
  final String popularity;
  final String adult;
  final String originalLanguage;
  final String overview;

  const MoviePage(
      {Key key,
      this.movieName,
      this.voteAverage,
      this.popularity,
      this.adult,
      this.originalLanguage,
      this.overview})
      : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(widget.movieName),
      ),
      body: Hero(
        tag: widget.movieName,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: new Image(
                  image: NetworkImage(
                      "https://www.johnwick.movie/media/images/home/bg.jpg"),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Card(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.star),
                            Text(
                              '${widget.voteAverage} / 10',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.person),
                            Text(
                              'Popularity : \n ${widget.popularity}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Adults : ${widget.adult}',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Text(
                'Language : ${widget.originalLanguage}',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Text(
                'Overview :',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.overview,
                style: TextStyle(wordSpacing: 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
