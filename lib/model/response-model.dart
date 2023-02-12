// ignore_for_file: file_names

class ResponseModel {
  final bool success;
  final int code;
  final dynamic meta;
  final dynamic data;
  final dynamic error;
  ResponseModel(
      {this.success = false, this.code = 0, this.meta, this.data, this.error});

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
      success: json["success"],
      code: json["code"],
      meta: json["meta"],
      data: json["data"],
      error: json["error"]);

  Map<String, dynamic> toJson() => {
        'success': success.toString(),
        'code': code.toString(),
        'meta': meta.toString(),
        'data': data.toString(),
        'error': error.toString()
      };
}
