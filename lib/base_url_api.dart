import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ApiUrl {
  //ip khi ở trường - 10.10.116.60
  //ip LAN nhà - 192.168.1.44
  static const baseUrl = 'http://10.0.2.2:6969/api/';

  static const apiGetAllAccount = '${baseUrl}accounts/all';

  ///// Api của Đạt-------------------------------------------------
  static const apiCreateAccount = '${baseUrl}account';
  //// Api của Quý-------------------------------------------------

  ///
  ///
  ///
  ///
  ///
}
