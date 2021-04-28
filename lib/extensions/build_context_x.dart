import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this.rootContext);

  TextTheme get textTheme => this.theme.textTheme;

  BuildContext get rootContext =>
      Navigator.of(this, rootNavigator: true).context;

  Size get screenSize => MediaQuery.of(this).size;

  double get h => this.screenSize.height;

  double get w => this.screenSize.width;

  void showAlertDialog(
      {bool isSingleAction = false,
      String title = 'title',
      String bodyText = 'bodyText',
      String pButtonText = 'YES',
      String nButtonText = 'NO',
      Function? pButtonBlock,
      Function? nButtonBlock}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      style: TextButton.styleFrom(primary: this.theme.primaryColor),
      child: Text(nButtonText),
      onPressed: () {
        Navigator.of(this).pop();
        if (nButtonBlock != null) {
          nButtonBlock();
        }
      },
    );
    Widget continueButton = TextButton(
      style: TextButton.styleFrom(primary: this.theme.primaryColor),
      child: Text(pButtonText),
      onPressed: () {
        Navigator.of(this).pop();
        if (pButtonBlock != null) {
          pButtonBlock();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        title,
      ),
      content: WillPopScope(
          child: Text(
            bodyText,
          ),
          onWillPop: () async => false),
      actions: isSingleAction
          ? [
              continueButton,
            ]
          : [
              cancelButton,
              continueButton,
            ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: this,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> showLoadingDialog() async {
    await showDialog(
      context: this,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: WillPopScope(
            onWillPop: () async => false,
            child: Container(
              width: context.w * 0.6,
              height: context.w * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text("Loading"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
