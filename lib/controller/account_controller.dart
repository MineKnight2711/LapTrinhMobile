import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/account_respone.dart';

class AccountController {
  Future<void> storedUserToSharedRefererces(
      AccountResponse accountResponse) async {
    final prefs = await SharedPreferences.getInstance();
    final accountJsonEncode = jsonEncode(accountResponse);
    await prefs.setString('currrent_account', accountJsonEncode);
  }

  Future<AccountResponse?> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('currrent_account') ?? '';
    if (jsonString.isNotEmpty) {
      return AccountResponse.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  Future<AccountResponse?> getUserFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('currrent_account') ?? '';
    if (jsonString.isNotEmpty) {
      return AccountResponse.fromJson(jsonDecode(jsonString));
    }
    return null;
  }
}
