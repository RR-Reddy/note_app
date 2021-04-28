import 'package:flutter/material.dart';
import 'package:notes_app/extensions/bool_x.dart';
import 'package:notes_app/extensions/extensions.dart';
import 'package:notes_app/services/auth_service.dart';

class DrawerHeadderWidget extends StatelessWidget {
  final bool isUserSignedIn;

  const DrawerHeadderWidget({Key? key, required this.isUserSignedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isUserSignedIn.not) {
      return Center(
        child: Text(" Please SignIn / SignUp"),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: context.theme.primaryColor,
          child: Text(
            AuthService().getUserIconLetter,
            style: context.textTheme.headline6!.copyWith(color: Colors.white),
          ),
        ),
        Container(height: 16),
        Text(
          AuthService().getDisplayName,
          style: context.textTheme.headline6,
        ),
        Text(AuthService().getEmail),
      ],
    );
  }
}
