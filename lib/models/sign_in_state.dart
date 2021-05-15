// client-side cookie is required/accessed by many widgets in the app
// therefore it should be maintained as a app-level state
import 'package:flutter/foundation.dart';

class SignInState extends ChangeNotifier {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;
  void signIn() {
    _isSignedIn = true;
    notifyListeners();
  }

  void signOut() {
    _isSignedIn = false;
    notifyListeners();
  }
}
