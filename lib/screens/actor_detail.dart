import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/apis/api.dart';
import 'package:movie_bank_mobile/constants.dart';
import 'package:movie_bank_mobile/models/actor.dart';
import 'package:movie_bank_mobile/models/movie.dart';
import 'package:movie_bank_mobile/screens/person_movies.dart';
import 'package:movie_bank_mobile/utils/custom_text_styles.dart';

class ActorDetail extends StatefulWidget {
  const ActorDetail({
    Key? key,
    required this.actorId,
  }) : super(key: key);

  final int actorId;

  @override
  _ActorDetailState createState() => _ActorDetailState();
}

class _ActorDetailState extends State<ActorDetail> {
  late Future<List<Movie>> movies;
  late Future<Actor> actorDetails;
  bool isShowingFullBio = false;

  @override
  void initState() {
    super.initState();
    actorDetails = fetchActorDetails(widget.actorId);
    movies = fetchMoviesOfActor(widget.actorId);
  }

  String getBioText(String bio) {
    return bio.length > 500 ? bio.substring(0, 500) + '...' : bio;
  }

  Widget getActorBio(String bio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isShowingFullBio ? bio : getBioText(bio),
          style: CustomTextStyles.text14(context),
          textAlign: TextAlign.justify,
        ),
        if (bio.length > 500)
          InkWell(
            onTap: () {
              setState(() {
                isShowingFullBio = !isShowingFullBio;
              });
            },
            child: Text(
              isShowingFullBio ? 'Show less-' : 'show more+',
              style: CustomTextStyles.text16(context),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Color(0xff323143),
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: FutureBuilder<Actor>(
                future: actorDetails,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Actor? actor = snapshot.data;
                    return Stack(
                      children: [
                        Hero(
                          tag: 'actor_${widget.actorId}}',
                          child: CachedNetworkImage(
                            imageUrl:
                                "$TMDB_WEB_URL/h632/${actor!.profilePath}",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.lighten,
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
                            top: MediaQuery.of(context).size.height * 0.55,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  actor.name,
                                  style: CustomTextStyles.text30(context),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff323143),
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Bio',
                                      style:
                                          CustomTextStyles.text20light(context),
                                    ),
                                    getActorBio(actor.biography),
                                    SizedBox(
                                      height: 70,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Text('');
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height - 70,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PersonMovies(personId: widget.actorId),
                  ),
                );
              },
              child: Container(
                color: Color(0xff323143),
                width: MediaQuery.of(context).size.width,
                height: 70,
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffa1a2d2),
                  ),
                  child: Center(
                    child: Text(
                      'VIEW MOVIES',
                      style: CustomTextStyles.text28(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
