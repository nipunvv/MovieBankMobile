import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/apis/api.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:movie_bank_mobile/screens/movie_detail.dart';

class PersonMovies extends StatefulWidget {
  const PersonMovies({
    Key? key,
    required this.personId,
  }) : super(key: key);

  final int personId;

  @override
  _PersonMoviesState createState() => _PersonMoviesState();
}

class _PersonMoviesState extends State<PersonMovies> {
  late Future<List<Movie>> movies;

  @override
  void initState() {
    super.initState();
    movies = fetchMoviesOfPerson(widget.personId);
  }

  List<Movie> getValidMovies(data) {
    if (data == null) return [];
    List<Movie> movies = data;
    return movies.where((movie) => movie.posterPath != '').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xff323143),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: FutureBuilder<List<Movie>>(
            future: movies,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Movie> movies = getValidMovies(snapshot.data);
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'MOVIES',
                            style: GoogleFonts.barlowCondensed(
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(.85),
                              letterSpacing: 2,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 1.0,
                            childAspectRatio: 0.67,
                            children: List.generate(
                              movies.length,
                              (index) {
                                return Container(
                                  width: 185,
                                  height: 360,
                                  padding: EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MovieDetail(
                                              movie: movies[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: 'movie_image${movies[index].id}',
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "$TMDB_WEB_URL/w185/${movies[index].posterPath}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
