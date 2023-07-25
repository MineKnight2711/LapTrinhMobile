import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/account_respone.dart';

class AccountController {
  final accountApi = Get.find<AccountApi>();

  Future<void> storedUserToSharedRefererces(
      AccountResponse accountResponse) async {
    final prefs = await SharedPreferences.getInstance();
    final accountJsonEncode = jsonEncode(accountResponse.toJson());
    await prefs.setString('current_account', accountJsonEncode);
  }

  Future<AccountResponse?> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('current_account') ?? '';
    if (jsonString.isNotEmpty) {
      return AccountResponse.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  Future<AccountResponse?> getUserFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('current_account') ?? '';
    if (jsonString.isNotEmpty) {
      return AccountResponse.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  Future logOut() async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.remove('current_account');
    accountApi.accountRespone.value = null;
    GoogleSignIn googleSignIn = GoogleSignIn();
    bool isSignin = await googleSignIn.isSignedIn();
    if (isSignin) {
      googleSignIn.signOut();
    }
    await FirebaseAuth.instance.signOut();
    FirebaseAuth.instance.userChanges();
    FirebaseAuth.instance.authStateChanges();
  }
}
