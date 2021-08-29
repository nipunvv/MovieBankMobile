import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';
import 'package:movie_bank_mobile/utils/page_utils.dart';

const CURRENT_PAGE = 2;

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff303043),
      bottomNavigationBar: getBottomNavigationBar(CURRENT_PAGE, context),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('favorites').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          // TODO: fetch movie and navigate to movie detail page
                        },
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl:
                                "$TMDB_WEB_URL/w342${docs[index]['movie_img']}",
                            width: MediaQuery.of(context).size.width * 0.1,
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
      ),
    );
  }
}
