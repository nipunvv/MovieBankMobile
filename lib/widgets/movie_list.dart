import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';

class MovieList extends StatelessWidget {
  const MovieList({
    Key? key,
    required this.movies,
    required this.changeMovie,
  }) : super(key: key);

  final List<Movie> movies;
  final Function changeMovie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Similar Movies',
            style: CustomTextStyles.text35(context),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            child: ListView.separated(
                physics: PageScrollPhysics(),
                separatorBuilder: (context, index) => Divider(
                      indent: 10,
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
                          changeMovie(movies[index]);
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
                }),
          ),
        ],
      ),
    );
  }
}
