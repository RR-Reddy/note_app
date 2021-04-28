import 'package:flutter/material.dart';
import 'package:notes_app/services/auth_service.dart';
import 'package:notes_app/extensions/extensions.dart';

class PasswordBodyWidget extends StatefulWidget {
  @override
  _PasswordBodyWidgetState createState() => _PasswordBodyWidgetState();
}

class _PasswordBodyWidgetState extends State<PasswordBodyWidget> {
  TextEditingController _pwdController = TextEditingController(text: '');
  TextEditingController _confirmController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPwdWidget(),
        _buildConfirmPwdWidget(),
        _buildChangePwdBtnWidget(),
      ],
    );
  }

  Widget _buildPwdWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: TextFormField(
        obscureText: true,
        controller: _pwdController,
        decoration: InputDecoration(
          labelText: 'New Password',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildConfirmPwdWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: TextFormField(
        obscureText: true,
        controller: _confirmController,
        decoration: InputDecoration(
          labelText: 'Confirm New Password',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildChangePwdBtnWidget() {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: ElevatedButton(
              onPressed: () => _onTap(context), child: Text('Change Password')),
        );
      },
    );
  }

  void _onTap(BuildContext context) async {

    // close keyboard
    FocusScope.of(context).unfocus();

    var pwd = _pwdController.text.trim().toString();
    var confirmPwd = _confirmController.text.trim().toString();

    String? errorMsg;

    // validations
    if (pwd.isEmpty) {
      errorMsg="Password should not be empty";
    }

    if(pwd!=confirmPwd){
      errorMsg="Password not matched";
    }

    if(errorMsg!=null){
      var snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text(errorMsg),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    context.showLoadingDialog();
    String? updateErrorMsg= await AuthService().updatePassword(pwd);
    // close loading dialog
    Navigator.of(context).pop();

    if(updateErrorMsg!=null){
      context.showAlertDialog(isSingleAction: true,title: 'Error',bodyText: updateErrorMsg);
    }else{
      Navigator.of(context).pop();
    }

  }


}
