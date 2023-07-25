import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_mobile_app/model/account_model.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import '../base_url_api.dart';
import '../controller/account_controller.dart';

class AccountApi extends GetxController {
  Rx<AccountResponse?> accountRespone = Rx<AccountResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCurrent();
  }

  Future fetchCurrent() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      accountRespone.value = await login(user.uid);
    }
  }

  Future<AccountResponse> login(String? accountId) async {
    AccountResponse accountResponseResult = AccountResponse();
    final response = await http.get(
      Uri.parse('${ApiUrl.apiFindAccountById}/$accountId'),
    );
    if (response.statusCode == 200) {
      accountResponseResult =
          AccountResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      accountRespone.value = accountResponseResult;
      await AccountController()
          .storedUserToSharedRefererces(accountResponseResult);
      accountResponseResult.status = "Đăng nhập thành công";
      return accountResponseResult;
    } else {
      accountResponseResult.status = "Đăng nhập thất bại";
      return accountResponseResult;
    }
  }

  Future<AccountModel?> register(AccountModel account) async {
    final response = await http.post(
      Uri.parse('${ApiUrl.apiCreateAccount}/${account.id}'),
      body: account.toJson(),
    );
    if (response.statusCode == 200) {
      AccountModel accounts = AccountModel.fromJson(jsonDecode(response.body));
      return accounts;
    }
    return null;
  }
}
