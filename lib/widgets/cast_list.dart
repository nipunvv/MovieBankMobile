import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/cast.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import 'package:movie_bank_mobile/models/credit.dart';
import 'package:movie_bank_mobile/widgets/actor_brief.dart';

class CastList extends StatelessWidget {
  const CastList({
    Key? key,
    required this.cast,
  }) : super(key: key);
  final List<Cast> cast;

  getBackgroundImage(imageUrl) {
    if (imageUrl == '') {
      return AssetImage('assets/images/avatar.jpg');
    } else {
      return NetworkImage("$TMDB_WEB_URL/w185/$imageUrl");
    }
  }

  Future<Credit> fetchCastDetails(String creditId) async {
    String url = "${TMDB_API_URL}credit/$creditId";
    final response = await http.get(
      Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: "Bearer $TMDB_API_KEY"},
    );

    if (response.statusCode == 200) {
      Credit credit = Credit.fromJson(jsonDecode(response.body));
      return credit;
    } else {
      throw Exception('Failed to load cast details');
    }
  }

  showCastDetails(BuildContext context, Cast actor) {
    Future<Credit> castDetails = fetchCastDetails(actor.creditId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 100,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: FutureBuilder<Credit>(
              future: castDetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Credit? credit = snapshot.data;
                  return ActorBrief(actor, credit, getBackgroundImage, () {});
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cast',
            style: GoogleFonts.barlowCondensed(
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(.85),
              letterSpacing: 2,
              fontSize: 35,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                math.min(cast.length, 10),
                (int i) {
                  return InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 10,
                      ),
                      child: Tooltip(
                        message: cast[i].name,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: getBackgroundImage(
                            cast[i].avatar,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      showCastDetails(context, cast[i]);
                    },
                    hoverColor: Colors.transparent,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}