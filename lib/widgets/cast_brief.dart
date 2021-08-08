import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/cast.dart';
import 'package:movie_bank_mobile/models/credit.dart';
import 'package:movie_bank_mobile/screens/actor_detail.dart';

class CastBrief extends StatelessWidget {
  final Cast actor;
  final Credit? credit;
  final Function getBackgroundImage;
  final String type;
  CastBrief(
    this.actor,
    this.credit,
    this.getBackgroundImage,
    this.type,
  );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'actor_${actor.id}',
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: getBackgroundImage(
                      actor.avatar,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actor.name,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (type == 'actor')
                      Text(
                        'as',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    if (type == 'actor')
                      Text(
                        actor.character,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'BEST KNOWN FOR',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var item in credit!.knownFor)
                  Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: "$TMDB_WEB_URL/w154/${item['poster_path']}",
                          fit: BoxFit.cover,
                          width: 70,
                          height: 120,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActorDetail(actorId: actor.id),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 2,
                ),
                child: Text(
                  'View profile',
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  child: Text(
                    'CLOSE',
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
