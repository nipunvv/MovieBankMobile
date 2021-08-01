import 'package:flutter/material.dart';

class ActorDetail extends StatelessWidget {
  const ActorDetail({
    Key? key,
    required this.actorId,
  }) : super(key: key);

  final int actorId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff303043),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
    );
  }
}
