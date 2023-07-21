import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_mobile_app/model/account_model.dart';
import '../base_url_api.dart';

class AccountApi extends GetxController {
  Future<AccountModel?> register(AccountModel account) async {
    print(account.toMap());
    final response = await http.post(
      Uri.parse(ApiUrl.baseUrl),
      body: {
        "id": account.id,
        // "password": account.password,
        "fullName": account.fullName,
        "email": account.email,
        // "birthday": '',
        // "gender": '',
        // "address": '',
        // "nickname": '',
        // "imageUrl": '',
        // "phone": '',
        "accountType": account.accountType,
      },
    );
    if (response.statusCode == 200) {
      AccountModel accounts = AccountModel.fromJson(jsonDecode(response.body));
      return accounts;
    }
    return null;
  }
}
