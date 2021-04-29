import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:notes_app/utils/app_utils.dart';
/// this service is responsible for user authentication flows
class AuthService {
  static final AuthService _instance = AuthService._internal();

  AuthService._internal();

  factory AuthService() => _instance;

  Future<bool> startAuthUiFlow() async {
    final providers = [
      AuthUiProvider.email,
      AuthUiProvider.google,
    ];

    final tosAndPrivacyPolicy = TosAndPrivacyPolicy(
      tosUrl: "https://www.google.com",
      privacyPolicyUrl: "https://www.google.com",
    );

    final androidOption = AndroidOption(
      enableSmartLock: false, // default true
      showLogo: false, // default false
      overrideTheme: true, // default false
    );

    final emailAuthOption = EmailAuthOption(
      requireDisplayName: true,
      // default true
      enableMailLink: false,
      // default false
      handleURL: '',
      androidPackageName: '',
      androidMinimumVersion: '',
    );

    return await FlutterAuthUi.startUi(
      items: providers,
      tosAndPrivacyPolicy: tosAndPrivacyPolicy,
      androidOption: androidOption,
      emailAuthOption: emailAuthOption,
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  User? _getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  bool get isSignedIn => _getUser()!=null;

  String get getDisplayName {
    var user = _getUser();
    return user == null ? "" : user.displayName ?? "";
  }

  String get getEmail {
    var user = _getUser();
    return user == null ? "" : user.email ?? "";
  }

  String get getUserIconLetter => getDisplayName.isEmpty
      ? 'U'
      : getDisplayName.toUpperCase().trim().substring(0, 1);

  String get uid => _getUser()?.uid ?? 'u';

  bool get isEmailProvider {
    var user = _getUser();
    if (user == null) {
      return false;
    }
    return 'password' == user.providerData.first.providerId;
  }

  Future<String?> updatePassword(String newPassword) async {
    String? errorMsg;

    try {
      await _getUser()!.updatePassword(newPassword);
    } catch (error) {
      AppUtils.logMsg(this, 'error : $error');
      errorMsg = error.toString();
    }

    return errorMsg;
  }
}
