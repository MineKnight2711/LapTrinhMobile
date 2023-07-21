import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_mobile_app/model/account_model.dart';
import '../base_url_api.dart';

class AccountApi extends GetxController {
  Future<AccountModel?> register(AccountModel account) async {
    print(account.toMap());
    final response = await http.post(
      Uri.parse('${ApiUrl.apiCreateAccount}/${account.id}'),
      body: {
        "fullName": account.fullName,
        "email": account.email,
        "birthday": DateFormat('yyyy-MM-dd').format(account.birthday!),
        "gender": account.gender,
        "address": account.address,
        "nickname": account.nickname,
        "imageUrl": '',
        "phone": account.phone,
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
