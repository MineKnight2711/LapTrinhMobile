import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/api/address_api.dart';
import 'package:keyboard_mobile_app/model/address_model.dart';
import 'package:logger/logger.dart';

import '../model/account_respone.dart';

class AddressController extends GetxController {
  late AddressApi addressApi;
  final accountApi = Get.find<AccountApi>();
  @override
  void onInit() {
    super.onInit();
    addressApi = Get.put(AddressApi());
  }

  final listAddress = Rx<List<AddressModel>?>([]);

  Future<AccountResponse?> awaitCurrentAccount() async {
    return await accountApi.fetchCurrent().then((currentAccount) {
      if (currentAccount != null) {
        return currentAccount;
      }
      return null;
    });
  }

  Future getListAddress() async {
    final currentAccount = await awaitCurrentAccount();
    Logger().i("${currentAccount?.accountId} log account");
    final respone =
        await addressApi.getAddressesByAccount("${currentAccount?.accountId}");
    if (respone.data != null) {
      final addresseReceived = respone.data as List<dynamic>;

      List<AddressModel> addressList = addresseReceived
          .map(
            (addressMap) => AddressModel.fromJson(addressMap),
          )
          .toList();
      listAddress.value = addressList;
    }
  }
}
