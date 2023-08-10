import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_mobile_app/model/account_model.dart';
import 'package:keyboard_mobile_app/model/account_respone.dart';
import 'package:keyboard_mobile_app/model/respone_base_model.dart';
import '../base_url_api.dart';
import '../controller/account_controller.dart';

class AccountApi extends GetxController {
  Rx<AccountResponse?> accountRespone = Rx<AccountResponse?>(null);
  final enableFingerprint = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCurrent();
  }

  Future<AccountResponse?> fetchCurrent() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      accountRespone.value = await login(user.uid);

      return accountRespone.value;
    }
    if (accountRespone.value != null) {
      accountRespone.value = await login(accountRespone.value!.accountId);
      return accountRespone.value;
    }
    return null;
  }

  Future<AccountResponse> login(String? accountId) async {
    ResponseBaseModel responseBase = ResponseBaseModel();
    AccountResponse accountResponseResult = AccountResponse();
    final response = await http.get(
      Uri.parse('${ApiUrl.apiFindAccountById}/$accountId'),
    );
    if (response.statusCode == 200) {
      responseBase = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      AccountResponse accountResponseResult = AccountResponse();
      accountResponseResult =
          accountRespone.value = AccountResponse.fromMap(responseBase.data);
      await AccountController().storedUserToSharedRefererces(
          AccountResponse.fromMap(responseBase.data));
      // accountResponseResult.status = "Đăng nhập thành công";
      return accountResponseResult;
    } else {
      // accountResponseResult.status = "Đăng nhập thất bại";
      return accountResponseResult;
    }
  }

  Future<ResponseBaseModel> findAccountById(String? accountId) async {
    ResponseBaseModel responseBase = ResponseBaseModel();
    final response = await http.get(
      Uri.parse('${ApiUrl.apiFindAccountById}/$accountId'),
    );
    if (response.statusCode == 200) {
      responseBase = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      return responseBase;
    } else {
      responseBase.message = "Fail";
      return responseBase;
    }
  }

  Future<ResponseBaseModel?> register(AccountModel account) async {
    final response = await http.post(
      Uri.parse('${ApiUrl.apiCreateAccount}/${account.accountId}'),
      body: account.toJson(),
    );
    ResponseBaseModel responseBase = ResponseBaseModel();
    if (response.statusCode == 200) {
      responseBase = ResponseBaseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      return responseBase;
    }
    responseBase.message = 'Error';
    return responseBase;
  }

  Future<ResponseBaseModel> changePassword(
      String? email, String newPassword) async {
    final url = Uri.parse(
        '${ApiUrl.apiChangePassword}/$email?newPassword=$newPassword');

    ResponseBaseModel responseBase = ResponseBaseModel();
    final response = await http.put(
      url,
    );
    if (response.statusCode == 200) {
      responseBase = ResponseBaseModel.fromJson(json.decode(response.body));
      return responseBase;
    } else {
      responseBase.message = 'Fail';
      return responseBase;
    }
  }

  Future<ResponseBaseModel> forgotPassword(String email) async {
    ResponseBaseModel responseBase = ResponseBaseModel();
    final url = Uri.parse('${ApiUrl.apiForgotPassword}/$email');
    final response = await http.post(
      url,
    );
    if (response.statusCode == 200) {
      responseBase = ResponseBaseModel.fromJson(json.decode(response.body));
      return responseBase;
    } else {
      responseBase.message = 'Fail';
      return responseBase;
    }
  }

  Future<ResponseBaseModel> updateAccount(AccountModel account) async {
    ResponseBaseModel responseBase = ResponseBaseModel();
    final url = Uri.parse('${ApiUrl.apiUpdateAccount}/${account.accountId}');
    final body = account.toJson();
    final response = await http.put(
      url,
      body: body,
    );
    if (response.statusCode == 200) {
      responseBase = ResponseBaseModel.fromJson(json.decode(response.body));
      return responseBase;
    } else {
      responseBase.message = 'Fail';
      return responseBase;
    }
  }

  Future<ResponseBaseModel> updateFingerprintAuthentication(
      AccountModel account) async {
    ResponseBaseModel responseBase = ResponseBaseModel();
    final url = Uri.parse(
        '${ApiUrl.apiUpdateFingerPrintAuthen}/${account.accountId}?isFingerprintEnabled=${account.isFingerPrintAuthentication}');

    final response = await http.put(
      url,
    );
    if (response.statusCode == 200) {
      responseBase = ResponseBaseModel.fromJson(json.decode(response.body));
      return responseBase;
    } else {
      responseBase.message = 'Fail';
      return responseBase;
    }
  }

  Future<ResponseBaseModel> changeImageUrl(
      String accountId, String newImageUrl) async {
    ResponseBaseModel responseBase = ResponseBaseModel();
    final url = Uri.parse(
        '${ApiUrl.apiChangeImage}/$accountId?newImageUrl=${Uri.encodeComponent(newImageUrl)}');

    final response = await http.put(
      url,
    );
    if (response.statusCode == 200) {
      responseBase = ResponseBaseModel.fromJson(json.decode(response.body));
      return responseBase;
    } else {
      responseBase.message = 'Fail';
      return responseBase;
    }
  }
}
