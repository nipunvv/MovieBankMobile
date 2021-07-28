import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> latestMovies;

  Future<List<Movie>> fetchMovies(String type) async {
    String url =
        "${TMDB_API_URL}movie/${type == 'popular' ? 'popular' : 'now_playing'}?language=en-US&page=1";
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
    );

    if (response.statusCode == 200) {
      List<Movie> movies = [];
      Movie m;
      for (Map<String, dynamic> movie in jsonDecode(response.body)['results']) {
        m = Movie.fromJson(movie);
        if (m.releaseDate != '') movies.add(m);
      }

      return movies;
    } else {
      throw Exception('Failed to load Movies');
    }
  }

  @override
  void initState() {
    super.initState();
    popularMovies = fetchMovies('popular');
    latestMovies = fetchMovies('latest');
  }

  Widget showMovies(String type) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: FutureBuilder<List<Movie>>(
        future: type == 'popular' ? popularMovies : latestMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Movie>? movies = snapshot.data;
            return CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.4,
                viewportFraction: 0.6,
                enlargeCenterPage: false,
                disableCenter: true,
                aspectRatio: 16 / 9,
                initialPage: 0,
                enableInfiniteScroll: false,
              ),
              items: movies!.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => MovieDetail(
                            //       item,
                            //     ),
                            //   ),
                            // );
                          },
                          child: Hero(
                            tag: 'movie_image${item.id}',
                            child: CachedNetworkImage(
                              imageUrl: "$TMDB_WEB_URL/w342/${item.posterPath}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xff303043),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'POPULAR',
                style: GoogleFonts.barlowCondensed(
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(.85),
                  letterSpacing: 2,
                  fontSize: 28,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              showMovies('popular'),
              SizedBox(
                height: 10,
              ),
              Text(
                'LATEST',
                style: GoogleFonts.barlowCondensed(
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(.85),
                  letterSpacing: 2,
                  fontSize: 28,
                ),
              ),
              showMovies('latest'),
            ],
          ),
        ),
      ),
    );
  }
}
