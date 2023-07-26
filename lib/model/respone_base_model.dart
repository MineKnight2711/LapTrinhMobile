class ResponseBaseModel {
  String? id;
  String? apiVersion;
  String? message;
  Map<String, dynamic>? data;

  ResponseBaseModel({
    this.apiVersion,
    this.id,
    this.message,
    this.data,
  });

  factory ResponseBaseModel.fromJson(Map<String, dynamic> json) {
    return ResponseBaseModel(
      id: json['id'],
      apiVersion: json['apiVersion'],
      message: json['message'],
      data: json['data'],
    );
  }
  // Map<String, dynamic> toJsonData() {
  //   return data as Map<String, dynamic>;
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> dataJson = toJsonData();
  //   final Map<String, dynamic> json = {
  //     'id': id,
  //     'apiVersion': apiVersion,
  //     'message': message,
  //     'data': dataJson,
  //   };
  //   return json;
  // }
}
