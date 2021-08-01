import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/cast.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:movie_bank_mobile/widgets/genre_list.dart';
import 'package:movie_bank_mobile/widgets/movie_header.dart';
import 'package:http/http.dart' as http;
import 'package:movie_bank_mobile/widgets/movie_meta.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  late Future<List<Cast>> cast;

  @override
  void initState() {
    super.initState();
    cast = fetchCast(widget.movie.id);
  }

  String getYearFromReleaseDate(String releaseDate) {
    if (releaseDate == '') return '';
    return releaseDate.substring(0, 4);
  }

  Future<List<Cast>> fetchCast(movieId) async {
    String url = "${TMDB_API_URL}movie/$movieId/credits";
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
    );

    if (response.statusCode == 200) {
      List<Cast> casts = [];
      for (Map<String, dynamic> cast in jsonDecode(response.body)['cast']) {
        Cast c = Cast.fromJson(cast);
        casts.add(c);
      }

      for (Map<String, dynamic> cast in jsonDecode(response.body)['crew']) {
        if (cast['department'] == 'Directing' && cast['job'] == 'Director') {
          Cast c = Cast.fromJson(cast);
          casts.add(c);
        }
      }

      return casts;
    } else {
      throw Exception('Failed to load cast');
    }
  }

  String getDirectorName(List<Cast> cast) {
    Cast director = cast.firstWhere((element) => element.job == 'Director');
    return director.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: 'movie_image_${widget.movie.category}_${widget.movie.id}',
                child: CachedNetworkImage(
                  imageUrl: "$TMDB_WEB_URL/w342${widget.movie.posterPath}",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
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
                top: MediaQuery.of(context).size.height * 0.7,
              ),
              color: Color(0xff1a1a24),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    padding: EdgeInsets.all(
                      10,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl:
                                "$TMDB_WEB_URL/w342${widget.movie.posterPath}",
                            width: MediaQuery.of(context).size.width * 0.35,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.525,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MovieMeta(
                                  title: 'Release Date',
                                  value: widget.movie.releaseDate),
                              MovieMeta(
                                  title: 'Vote Count',
                                  value: widget.movie.voteCount.toString()),
                              MovieMeta(
                                  title: 'Duration',
                                  value: widget.movie.runtime.toString()),
                              Row(
                                children: [
                                  Text(
                                    'Director: ',
                                    style: GoogleFonts.barlowCondensed(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffa1a2d2),
                                      letterSpacing: 2,
                                      fontSize: 16,
                                    ),
                                  ),
                                  FutureBuilder<List<Cast>>(
                                    future: cast,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<Cast>? cast = snapshot.data ?? [];
                                        return Text(
                                          getDirectorName(cast),
                                          style: GoogleFonts.barlowCondensed(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            letterSpacing: 2,
                                            fontSize: 14,
                                          ),
                                        );
                                      }
                                      return Text('');
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      widget.movie.title,
                      style: GoogleFonts.barlowCondensed(
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(.85),
                        letterSpacing: 2,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GenreList(genreIds: widget.movie.genreIds),
                  SizedBox(
                    height: 10,
                  ),
                  MovieHeader(
                    releaseYear:
                        getYearFromReleaseDate(widget.movie.releaseDate),
                    rating: widget.movie.voteAvg.toString(),
                    language: widget.movie.language,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
