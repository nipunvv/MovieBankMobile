import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/apis/api.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';
import 'package:movie_bank_mobile/utils/page_utils.dart';

const CURRENT_PAGE = 1;

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchFieldController = TextEditingController();
  bool isSearching = false;
  List<Movie> searchResults = [];

  searchMovies(String keyword) async {
    setState(() {
      isSearching = true;
    });
    findMovies(keyword).then((movies) {
      setState(() {
        searchResults = movies;
        isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff303043),
      bottomNavigationBar: getBottomNavigationBar(CURRENT_PAGE, context),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 50,
                    child: TextField(
                      controller: searchFieldController,
                      showCursor: true,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        searchMovies(value);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: CustomTextStyles.text18light(context),
                      cursorWidth: 1,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xffa1a2d2),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                      ),
                      onPressed: () => searchMovies(searchFieldController.text),
                    ),
                  ),
                ],
              ),
              Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (item, index) {
                      Movie movie = searchResults[index];
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: "$TMDB_WEB_URL/w342${movie.posterPath}",
                          width: MediaQuery.of(context).size.width * 0.1,
                          fit: BoxFit.contain,
                        ),
                        title: Text(
                          movie.title,
                          style: CustomTextStyles.text14(context),
                        ),
                        subtitle: Text(
                          movie.releaseDate,
                          style: CustomTextStyles.text14(context),
                        ),
                      );
                      return Text(searchResults[index].title);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
