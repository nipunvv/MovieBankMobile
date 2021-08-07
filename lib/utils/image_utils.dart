import 'package:flutter/material.dart';
import 'package:movie_bank_mobile/constants.dart';

getBackgroundImage(imageUrl) {
  if (imageUrl == '') {
    return AssetImage('assets/images/avatar.jpg');
  } else {
    return NetworkImage("$TMDB_WEB_URL/w185/$imageUrl");
  }
}
