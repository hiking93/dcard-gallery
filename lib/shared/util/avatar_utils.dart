import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AvatarUtils {
  static SvgPicture getGenderAvatar(
      {@required String gender, double width, double height}) {
    String assetName;
    switch (gender) {
      case 'M':
      case 'm':
        assetName = 'assets/ic_avatar_male.svg';
        break;
      case 'F':
      case 'f':
        assetName = 'assets/ic_avatar_female.svg';
        break;
      case 'D':
      case 'd':
        assetName = 'assets/ic_avatar_dcard.svg';
        break;
      default:
        assetName = 'assets/ic_avatar_neutral.svg';
    }
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
    );
  }

  static Widget getPersonaAvatar({
    @required String gender,
    @required String personaId,
    double width,
    double height,
  }) {
    int color;
    switch (gender) {
      case 'M':
      case 'm':
        color = 0xff006ea5;
        break;
      case 'F':
      case 'f':
        color = 0xffb73567;
        break;
      case 'D':
      case 'd':
        return getGenderAvatar(gender: gender, width: width, height: height);
      default:
        color = 0xff37474f;
    }
    return Container(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(color),
          shape: BoxShape.circle,
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            gender.substring(0, 1).toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
