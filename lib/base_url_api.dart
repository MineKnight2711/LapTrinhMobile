class ApiUrl {
  //ip khi ở trường - 10.10.116.60
  //ip LAN nhà - 192.168.1.44
  //ip Coffee House NTT 172.16.3.8
  //ip mạng ảo của giả lập - 10.0.2.2
  //ip wifi nhà - 192.168.0.106
  //ip mobile hostspot - 192.168.29.192/192.168.191.192
  //ip debug lan - 192.168.93.160/192.168.93.111

  static const baseUrl = 'http://10.0.2.2:6969/api/';

  static const apiGetAllAccount = '${baseUrl}accounts/all';

  ///// Api của Đạt-------------------------------------------------
  static const apiCreateAccount = '${baseUrl}account';
  static const apiFindAccountById = '${baseUrl}account';
  static const apiChangePassword = '${baseUrl}account';
  static const apiForgotPassword = '${baseUrl}account/reset-password';
  static const apiGetProductById = '${baseUrl}product/getById';
  static const apiGetProductDetailsById = '${baseUrl}productDetail/getById';
  static const apiUpdateCart = '${baseUrl}cart/update';
  static const apiClearCart = '${baseUrl}cart/clear-cart';
  static const apiUpdateFingerPrintAuthen = '${baseUrl}account/fingerprint';
  static const apiDeleteAddress = '${baseUrl}address/delete';
  static const apiGetAllReview = '${baseUrl}review';
  static const apiCreateReview = '${baseUrl}review/create';
  static const apiChangeImage = '${baseUrl}account/updateImage';
  static const apiGetAndFetchAllOrder = '${baseUrl}order/testGetOrder';
  //// Api của Quý-------------------------------------------------
  static const apiUpdateAccount = '${baseUrl}account/info';
  static const apiGetAllCategory = '${baseUrl}category';
  static const apiGetProductByCategory = '${baseUrl}product/category';
  static const apiGetProductDetails = '${baseUrl}productDetail/listProduct';
  static const apiGetCartByAccount = '${baseUrl}cart';
  static const apiAddToCart = '${baseUrl}cart/add';
  static const apiDeleteItemFromCart = '${baseUrl}cart/delete';
  static const apiDeleteManyItemFromCart = '${baseUrl}cart/deleteMany';
  static const apiGetAddressByAccountId = '${baseUrl}address/getList';
  static const apiAddAddress = '${baseUrl}address/create';
  static const apiUpdateAddress = '${baseUrl}address/update';

  static const apiCreateOrder = '${baseUrl}order/create';
  static const apiUpdateOrderStatus = '${baseUrl}order/update';

  ///
  ///
  ///
  ///
  ///
}
