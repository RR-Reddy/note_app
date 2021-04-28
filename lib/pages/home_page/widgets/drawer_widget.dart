import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/blocs/user_auth_cubit.dart';
import 'package:notes_app/extensions/bool_x.dart';
import 'package:notes_app/pages/password_page/password_page.dart';
import 'package:notes_app/services/auth_service.dart';

import 'drawer_headder_widget.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:
          BlocBuilder<UserAuthCubit, bool>(builder: (context, isUserSingedIn) {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 40, bottom: 16),
              child: DrawerHeadderWidget(isUserSignedIn: isUserSingedIn),
            ),
            Divider(height: 1, thickness: 1),
            if (isUserSingedIn.not)
              ListTile(
                leading: Icon(Icons.login),
                title: Text('SignIn / SignUp'),
                onTap: () {
                  // close drawer
                  Navigator.of(context).pop();
                  AuthService().startAuthUiFlow();
                },
              ),
            if (isUserSingedIn && AuthService().isEmailProvider)
              ListTile(
                leading: Icon(Icons.update),
                title: Text('Change Password'),
                onTap: () {
                  // close drawer
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(PasswordPage.routeName);
                },
              ),
            if (isUserSingedIn)
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  // close drawer
                  Navigator.of(context).pop();
                  AuthService().logout();
                },
              ),
          ],
        );
      }),
    );
  }
}
