import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  // static Future<List<BiometricType>> getBiometrics() async {
  //   try {
  //     return await _auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     return <BiometricType>[];
  //   }
  // }

  static Future<String> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return 'NoBiometrics';
    try {
      await _auth.authenticate(
        biometricOnly: true,
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      return 'Success';
    } on PlatformException {
      return 'BiometricsNotEnable';
    }
  }
}
