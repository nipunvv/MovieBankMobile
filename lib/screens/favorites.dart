import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/apis/api.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/screens/movie_detail.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';
import 'package:movie_bank_mobile/utils/page_utils.dart';

const CURRENT_PAGE = 2;

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  fetchMovieData(BuildContext context, num movieId) {
    fetchMovieDetails(movieId).then((movie) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetail(
            movie: movie,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getBottomNavigationBar(CURRENT_PAGE, context),
      body: SafeArea(
        child: Container(
          color: Color(0xff303043),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10,
                ),
                child: Text(
                  'FAVORITES',
                  style: CustomTextStyles.text30(context),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                ),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('favorites')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var docs = snapshot.data!.docs;

                    return Container(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (item, index) {
                            return InkWell(
                              onTap: () {
                                fetchMovieData(
                                  context,
                                  docs[index]['movie_id'],
                                );
                              },
                              child: ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl:
                                      "$TMDB_WEB_URL/w342${docs[index]['movie_img']}",
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  fit: BoxFit.contain,
                                ),
                                title: Text(
                                  docs[index]['movie_name'],
                                  style: CustomTextStyles.text14(context),
                                ),
                                subtitle: Text(
                                  docs[index]['movie_year'],
                                  style: CustomTextStyles.text14(context),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
