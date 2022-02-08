import 'package:laravelflutter/providers/auth/firebase/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, VoidCallback;
import 'package:flutter/widgets.dart' show TextEditingController;

enum PhoneAuthState {
  Started,
  CodeSent,
  CodeResent,
  Verified,
  Failed,
  Error,
  AutoRetrievalTimeOut
}

class PhoneAuthDataProvider with ChangeNotifier {
  VoidCallback onStarted,
      onCodeSent,
      onCodeResent,
      onVerified,
      onFailed,
      onError,
      onAutoRetrievalTimeout;

  bool _loading = false;

  final TextEditingController _phoneNumberController = TextEditingController();

  PhoneAuthState? _status;
  var _authCredential;
  String? _actualCode;
  String? _phone, _message;

  setMethods(
      {VoidCallback onStarted,
      VoidCallback onCodeSent,
      VoidCallback onCodeResent,
      VoidCallback onVerified,
      VoidCallback onFailed,
      VoidCallback onError,
      VoidCallback onAutoRetrievalTimeout}) {
    this.onStarted = onStarted;
    this.onCodeSent = onCodeSent;
    this.onCodeResent = onCodeResent;
    this.onVerified = onVerified;
    this.onFailed = onFailed;
    this.onError = onError;
    this.onAutoRetrievalTimeout = onAutoRetrievalTimeout;
  }

  Future<bool> instantiate(
      {String dialCode,
      VoidCallback onStarted,
      VoidCallback onCodeSent,
      VoidCallback onCodeResent,
      VoidCallback onVerified,
      VoidCallback onFailed,
      VoidCallback onError,
      VoidCallback onAutoRetrievalTimeout}) async {
    this.onStarted = onStarted;
    this.onCodeSent = onCodeSent;
    this.onCodeResent = onCodeResent;
    this.onVerified = onVerified;
    this.onFailed = onFailed;
    this.onError = onError;
    this.onAutoRetrievalTimeout = onAutoRetrievalTimeout;

    if (phoneNumberController.text.length < 9) {
      return false;
    }
    phone = dialCode + phoneNumberController.text;
    print(phone);
    _startAuth();
    return true;
  }


  _startAuth() {
    // ignore: prefer_function_declarations_over_variables
    final Future<void> Function(String verificationId, [int forceResendingToken]) codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      actualCode = verificationId;
      _addStatusMessage("\nEntrez le code envoyé à " + phone);
      _addStatus(PhoneAuthState.CodeSent);
      onCodeSent();
    };

// ignore: prefer_function_declarations_over_variables
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      actualCode = verificationId;
      _addStatusMessage("\nExpiration du délai de récupération automatique");
      _addStatus(PhoneAuthState.AutoRetrievalTimeOut);
      if (onAutoRetrievalTimeout != null) {
        onAutoRetrievalTimeout();
      }
    };

// ignore: prefer_function_declarations_over_variables
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      _addStatusMessage('${authException.message}');
      _addStatus(PhoneAuthState.Failed);
      if (onFailed != null) onFailed();
      if (authException.message!.contains('Pas autorisé')) {
        _addStatusMessage('Application non autorisée');
      } else {
        if (authException.message!.contains('Network')) {
        _addStatusMessage(
            "La connexion internet n'est pas stable ");
      } else {
        _addStatusMessage('Une erreur vient de se produire. Merci de réessayer ' +
            authException.message!);
      }
      }
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      _addStatusMessage('Récupération automatique du code de vérification');

      FireBase.auth.signInWithCredential(auth).then((AuthResult value) {
        if (value.user != null) {
          _addStatusMessage('Authentification réussie');
          _addStatus(PhoneAuthState.Verified);
          onVerified();
        } else {
          if (onFailed != null) onFailed();
          _addStatus(PhoneAuthState.Failed);
          _addStatusMessage('Le code que vous avez saisi est invalide');
        }
      }).catchError((error) {
        if (onError != null) onError();
        _addStatus(PhoneAuthState.Error);
        _addStatusMessage("Quelque chose s'est mal passé, veuillez réessayer plus tard $error");
      });
    };

    _addStatusMessage("L'authentification par téléphone a commencé");
    FireBase.auth
        .verifyPhoneNumber(
            phoneNumber: phone.toString(),
            timeout: const Duration(seconds: 1000),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
        .then((value) {
       onCodeSent();
      _addStatus(PhoneAuthState.CodeSent);
      _addStatusMessage('Code sent');
    }).catchError((error) {
      onError();
      _addStatus(PhoneAuthState.Error);
      _addStatusMessage(error.toString());
    });
  }


  void verifyOTPAndLogin({String? smsCode}) async {
    _authCredential = PhoneAuthProvider.credential(
        verificationId: actualCode, smsCode: smsCode!);

    FireBase.auth
        .signInWithCredential(_authCredential)
        .then((AuthResult result) async {

          await  Firestore.instance.collection('users').document(result.user.uid).get().then((DocumentSnapshot snapshot) async {


         }).whenComplete((){

          _addStatusMessage('Authentication éfféctuée avec succès');
          _addStatus(PhoneAuthState.Verified);
          if (onVerified != null) onVerified();

        });


    }).catchError((error) {
      if (onError != null) onError();
      _addStatus(PhoneAuthState.Error);
      _addStatusMessage(
          "Quelque chose s'est mal passée, veuillez réessayer plus tard  $error");
    });
  }

  _addStatus(PhoneAuthState state) {
    status = state;
  }

  void _addStatusMessage(String s) {
    message = s;
  }

  get authCredential => _authCredential;

  set authCredential(value) {
    _authCredential = value;
    notifyListeners();
  }

  get actualCode => _actualCode;

  set actualCode(String value) {
    _actualCode = value;
    notifyListeners();
  }

  get phone => _phone;

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  get message => _message;

  set message(String value) {
    _message = value;
    notifyListeners();
  }

  get status => _status;

  set status(PhoneAuthState value) {
    _status = value;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  TextEditingController get phoneNumberController => _phoneNumberController;

}
