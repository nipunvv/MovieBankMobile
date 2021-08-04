import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
  bool isShowingFullBio = true;

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

  String getBioText(String bio) {
    return bio.length > 500 ? bio.substring(0, 500) : bio;
  }

  Widget getActorBio(String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getBioText(bio),
          style: GoogleFonts.barlowCondensed(
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
            letterSpacing: 2,
            fontSize: 14,
          ),
        ),
        if (bio.length > 500)
          InkWell(
            onTap: () {
              //
            },
            child: Text(
              'show more+',
              style: GoogleFonts.barlowCondensed(
                fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(0.9),
                letterSpacing: 2,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff323143),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<Actor>(
            future: actorDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Actor? actor = snapshot.data;
                return Stack(
                  children: [
                    Hero(
                      tag: 'actor_${widget.actorId}}',
                      child: CachedNetworkImage(
                        imageUrl: "$TMDB_WEB_URL/h632/${actor!.profilePath}",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.lighten,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.grey.withOpacity(0.0),
                            Color(0xff303043),
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.55,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              actor.name,
                              style: GoogleFonts.barlowCondensed(
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(.85),
                                letterSpacing: 2,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff323143),
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Bio',
                                  style: GoogleFonts.barlowCondensed(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffa1a2d2),
                                    letterSpacing: 2,
                                    fontSize: 20,
                                  ),
                                ),
                                getActorBio(actor.biography),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Text('');
            },
          ),
        ),
      ),
    );
  }
}
