import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/apis/api.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:movie_bank_mobile/providers/provider.dart';
import 'package:movie_bank_mobile/screens/movie_detail.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';
import 'package:movie_bank_mobile/utils/page_utils.dart';
import 'package:provider/provider.dart';

const CURRENT_PAGE = 0;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> latestMovies;
  final double dividerIndent = 10;

  @override
  void initState() {
    super.initState();
    popularMovies = fetchMovies('popular');
    latestMovies = fetchMovies('latest');
    final genreModel = Provider.of<GenreProvider>(context, listen: false);
    genreModel.getGenreData();
  }

  Widget showMovies(String type) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.30,
      ),
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: FutureBuilder<List<Movie>>(
        future: type == 'popular' ? popularMovies : latestMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Movie>? movies = snapshot.data ?? [];
            return ListView.separated(
                physics: PageScrollPhysics(),
                separatorBuilder: (context, index) => Divider(
                      indent: dividerIndent,
                    ),
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
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
                          tag:
                              'movie_image_${movies[index].category}_${movies[index].id}',
                          child: CachedNetworkImage(
                            imageUrl:
                                "$TMDB_WEB_URL/w342${movies[index].posterPath}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                });
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
      appBar: AppBar(
        title: Text(
          'MOVIE BANK',
          style: CustomTextStyles.text28(context),
        ),
      ),
      bottomNavigationBar: getBottomNavigationBar(CURRENT_PAGE, context),
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
                style: CustomTextStyles.text28(context),
              ),
              SizedBox(
                height: 10,
              ),
              showMovies('popular'),
              SizedBox(
                height: 20,
              ),
              Text(
                'LATEST',
                style: CustomTextStyles.text28(context),
              ),
              SizedBox(
                height: 10,
              ),
              showMovies('latest'),
            ],
          ),
        ),
      ),
    );
  }
}
