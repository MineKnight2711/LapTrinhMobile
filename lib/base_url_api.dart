class ApiUrl {
  //ip khi ở trường - 10.10.116.60
  //ip LAN nhà - 192.168.1.44
  //ip mạng ảo của giả lập - 10.0.2.2
  //ip wifi nhà - 192.168.0.106
  //ip mobile hostspot - 192.168.29.192
  static const baseUrl = 'http://192.168.1.44:6969/api/';

  static const apiGetAllAccount = '${baseUrl}accounts/all';

  ///// Api của Đạt-------------------------------------------------
  static const apiCreateAccount = '${baseUrl}account';
  static const apiFindAccountById = '${baseUrl}account';
  static const apiChangePassword = '${baseUrl}account';
  //// Api của Quý-------------------------------------------------

  ///
  ///
  ///
  ///
  ///
}
