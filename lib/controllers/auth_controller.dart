import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController{
  RxBool loading = RxBool(false);

  final Rxn<User> _user = Rxn<User>();
  User get user => _user.value!;
  bool get isLoggedIn => _user.value != null;

  final _authInstance = FirebaseAuth.instance;

  @override
  void onInit() async{
    super.onInit();
    _user(_authInstance.currentUser);

    /// update profile based on user auth state change
    _authInstance.authStateChanges().listen(_user);

    /// update profile based on changes in user profile
    _authInstance.userChanges().listen(_user);
  }

  Future<void> googleAuth() async {
    loading(true);
    try {
      const List<String> scopes = <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];

      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: scopes,
      );

      GoogleSignInAccount? googleAcc = await googleSignIn.signIn();


      if (googleAcc == null) {
        Get.showSnackbar(GetSnackBar(
          message: 'Login failed',
          duration: Duration(seconds: 2),
        ));
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleAcc.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _authInstance.signInWithCredential(credential);

      userCred.user!
        ..updateDisplayName(googleAcc.displayName)
        ..updatePhotoURL(googleAcc.photoUrl);
    } catch (err) {
      Get.showSnackbar(GetSnackBar(
        message: err.toString(),
        duration: Duration(seconds: 2),
      ));
      loading(false);
    }
    loading(false);
  }
}