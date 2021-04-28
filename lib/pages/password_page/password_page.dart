import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/pages/password_page/widgets/password_body_widget.dart';

/// Password Change UI Page
class PasswordPage extends StatelessWidget {
  static const routeName = '/password_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),body: PasswordBodyWidget(),
    );
  }
}
