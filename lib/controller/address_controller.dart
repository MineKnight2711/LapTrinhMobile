import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:keyboard_mobile_app/api/account_api.dart';
import 'package:keyboard_mobile_app/api/address_api.dart';
import 'package:keyboard_mobile_app/model/address_model.dart';
import 'package:keyboard_mobile_app/utils/data_convert.dart';
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

  //Add address controllers********************************
  final receiverNameController = TextEditingController();
  final receiverPhoneController = TextEditingController();
  final houseAndStreetController = TextEditingController();
  final wardController = TextEditingController();
  final districtAndCityController = TextEditingController();

  final defaultAddress = false.obs;

  final isValidReceiverName = false.obs;
  final isValidReceiverPhone = false.obs;
  final isValidHouseAndStreet = false.obs;
  final isValidWard = false.obs;
  final isValidDistrictAndCity = false.obs;

  String? validateReceiverName(String? receiverName) {
    if (receiverName == null || receiverName.isEmpty) {
      isValidReceiverName.value = false;
      return 'Tên người nhận không được trống!';
    }
    isValidReceiverName.value = true;
    return null;
  }

  String? validateReceiverPhone(String? phonenumber) {
    if (phonenumber == null || phonenumber.isEmpty) {
      isValidReceiverPhone.value = false;
      return 'Số điện thoại không được trống!';
    }
    RegExp regex = RegExp(r'^(84|0)[35789]([0-9]{8})$');
    if (!regex.hasMatch(phonenumber)) {
      return 'Số điện thoại không đúng định dạng!';
    }
    isValidReceiverPhone.value = true;
    return null;
  }

  String? validateHouseAndStreet(String? houseStreet) {
    if (houseStreet == null || houseStreet.isEmpty) {
      isValidHouseAndStreet.value = false;
      return 'Trường này không được trống!';
    }
    isValidHouseAndStreet.value = true;
    return null;
  }

  String? validateWard(String? ward) {
    if (ward == null || ward.isEmpty) {
      isValidWard.value = false;
      return 'Trường này không được trống!';
    }
    isValidWard.value = true;
    return null;
  }

  String? validateDistrictAndCity(String? districtAndCity) {
    if (districtAndCity == null || districtAndCity.isEmpty) {
      isValidDistrictAndCity.value = false;
      return 'Trường này không được trống!';
    }
    isValidDistrictAndCity.value = true;
    return null;
  }

  Future<String> addAddress(String accountId) async {
    AddressModel newAddress = AddressModel();
    newAddress.accountId = accountId;
    newAddress.receiverName = receiverNameController.text;
    newAddress.receiverPhone = receiverPhoneController.text;
    newAddress.address =
        "${houseAndStreetController.text}-${wardController.text}-${districtAndCityController.text}";
    newAddress.defaultAddress = defaultAddress.value;
    final respone = await addressApi.addAddress(newAddress);
    if (respone.message!.contains("success")) {
      return "Success";
    }
    return "Fail";
  }

  void onFinishingAddAddress() {
    receiverNameController.clear();
    receiverPhoneController.clear();
    houseAndStreetController.clear();
    wardController.clear();
    districtAndCityController.clear();
    defaultAddress.value = isValidReceiverName.value =
        isValidReceiverPhone.value = isValidHouseAndStreet.value =
            isValidWard.value = isValidDistrictAndCity.value = false;
  }

  //Update address controllers********************************
  final updateReceiverNameController = TextEditingController();
  final updateReceiverPhoneController = TextEditingController();
  final updateHouseAndStreetController = TextEditingController();
  final updateWardController = TextEditingController();
  final updateDistrictAndCityController = TextEditingController();
  final updateDefaultAddress = false.obs;

  void fetchCurrentAddress(AddressModel selectedAddress) {
    updateReceiverNameController.text = selectedAddress.receiverName ?? '';
    updateReceiverPhoneController.text = selectedAddress.receiverPhone ?? '';
    //Tạo 1 danh sách chuỗi thông tin địa chỉ được phân giải từ database
    List<String> listSplitAddress =
        DataConvert().splitAddress("${selectedAddress.address}");
    // Tạo một danh sách chứa 3 chuỗi rỗng
    List<String> targetParts = ['', '', ''];
    //Hàm lặp qua từng phần tử của danh sách chuỗi sau khi phân giải và gán từng phần tử cho danh sách chuỗi rỗng trên
    //Làm như vầy để tránh trường hợp 1 trong các trường địa chỉ bị rỗng
    assignAddressParts(listSplitAddress, targetParts);

    updateHouseAndStreetController.text = targetParts[0];
    updateWardController.text = targetParts[1];
    updateDistrictAndCityController.text = targetParts[2];
    updateDefaultAddress.value = selectedAddress.defaultAddress ?? false;
  }

  void assignAddressParts(List<String> splitAddress, List<String> targetParts) {
    //Vòng lập for để duyệt danh sách chuỗi truyền vào cũng như danh sách chuỗi mục tiêu
    //Đảm bảo từng phần tử của danh sách chuỗi truyền vào khớp với danh sách chuỗi nhận
    for (int i = 0; i < splitAddress.length && i < targetParts.length; i++) {
      targetParts[i] = splitAddress[i];
    }
  }

  Future<String> deleteAddress(String addressId) async {
    final respone = await addressApi.deleteAddress(addressId);
    switch (respone.message) {
      case 'DeleteSuccess':
        return 'Success';
      case 'IsDefault':
        return 'Không thể xoá địa chỉ mặc định!';
      case 'AddressNotFound':
        return 'Không tìm thấy địa chỉ!';
      default:
        return 'Có lỗi xảy ra';
    }
  }
}
