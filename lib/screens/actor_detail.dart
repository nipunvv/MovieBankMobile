import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/actor.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:http/http.dart' as http;

class ActorDetail extends StatefulWidget {
  const ActorDetail({
    Key? key,
    required this.actorId,
  }) : super(key: key);

  final int actorId;

  @override
  _ActorDetailState createState() => _ActorDetailState();
}

class _ActorDetailState extends State<ActorDetail> {
  late Future<List<Movie>> movies;
  late Future<Actor> actorDetails;

  @override
  void initState() {
    super.initState();
    actorDetails = fetchActorDetails(widget.actorId);
    movies = fetchMoviesOfActor(widget.actorId);
  }

  Future<Actor> fetchActorDetails(int actorId) async {
    String url = "${TMDB_API_URL}person/$actorId";
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
    );

    if (response.statusCode == 200) {
      Actor actor = Actor.fromJson(jsonDecode(response.body));
      return actor;
    } else {
      throw Exception('Failed to load actor details');
    }
  }

  Future<List<Movie>> fetchMoviesOfActor(int actorId) async {
    String url = "${TMDB_API_URL}person/$actorId/movie_credits";
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
    );

    if (response.statusCode == 200) {
      List<Movie> movies = [];
      for (Map<String, dynamic> movie in jsonDecode(response.body)['cast']) {
        movies.add(Movie.fromJson(movie));
      }

      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff303043),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 30,
        ),
        child: FutureBuilder<Actor>(
          future: actorDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Actor? actor = snapshot.data;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            "$TMDB_WEB_URL/w185/${actor!.profilePath}"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        actor.name,
                        style: GoogleFonts.barlowCondensed(
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(.85),
                          letterSpacing: 2,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
            return Text('');
          },
        ),
      ),
    );
  }
}
