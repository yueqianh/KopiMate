import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    // Interactive sign in process.
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // Obtain auth details.
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // Create new credentials.
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in.
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
