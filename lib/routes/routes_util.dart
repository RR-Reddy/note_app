import 'package:flutter/material.dart';
import 'package:notes_app/domain/note.dart';
import 'package:notes_app/pages/home_page/home_page.dart';
import 'package:notes_app/pages/note_page/note_page.dart';
import 'package:notes_app/pages/password_page/password_page.dart';

/// handles named routes with slide transition
class RoutesUtil {
  /// generates animated route
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        switch (settings.name) {
          case HomePage.routeName:return HomePage();
          case NotePage.routeName:return NotePage(note: settings.arguments as Note);
          case PasswordPage.routeName:return PasswordPage();
          default:
            throw Exception('unknown route : ${settings.name}');
        }
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
