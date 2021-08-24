import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_bank_mobile/apis/api.dart';
import 'package:movie_bank_mobile/models/cast.dart';
import 'dart:math' as math;

import 'package:movie_bank_mobile/models/credit.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';
import 'package:movie_bank_mobile/utils/image_utils.dart';
import 'package:movie_bank_mobile/widgets/cast_brief.dart';

class CastList extends StatelessWidget {
  const CastList({
    Key? key,
    required this.cast,
  }) : super(key: key);
  final List<Cast> cast;

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
                  return CastBrief(
                    actor,
                    credit,
                    getBackgroundImage,
                    'actor',
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
        );
      },
    );
  }

  showFullCast(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: Duration(
        milliseconds: 400,
      ),
      pageBuilder: (_, __, ___) {
        return Scaffold(
          backgroundColor: Color(0xff303043).withOpacity(0.85),
          body: SafeArea(
            child: SizedBox(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 98,
                    child: ListView.builder(
                      itemCount: cast.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: getBackgroundImage(
                                cast[index].avatar,
                              ),
                            ),
                            title: Text(
                              cast[index].name,
                              style: CustomTextStyles.text14(context),
                            ),
                            subtitle: Text(
                              cast[index].character,
                              style: CustomTextStyles.text14light(context),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              showCastDetails(context, cast[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 70,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'close',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
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
            style: CustomTextStyles.text35(context),
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
                math.min(cast.length, 11),
                (int i) {
                  if (i == 10)
                    return InkWell(
                      onTap: () {
                        showFullCast(context);
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xffa1a2d2),
                        ),
                        child: Center(
                          child: Text(
                            'view\nall',
                            style: CustomTextStyles.text14(context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
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
