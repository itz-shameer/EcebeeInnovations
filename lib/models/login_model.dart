import 'package:meta/meta.dart';
import 'dart:convert';

class Loginmodel {
  final String mobile;
  final String genNumb;
  final String logTime;
  final String ip;
  final String location;

  Loginmodel({
    required this.mobile,
    required this.genNumb,
    required this.logTime,
    required this.ip,
    required this.location,
  });

  Loginmodel copyWith({
    String? mobile,
    String? genNumb,
    String? logTime,
    String? ip,
    String? location,
  }) =>
      Loginmodel(
        mobile: mobile ?? this.mobile,
        genNumb: genNumb ?? this.genNumb,
        logTime: logTime ?? this.logTime,
        ip: ip ?? this.ip,
        location: location ?? this.location,
      );

  factory Loginmodel.fromRawJson(String str) =>
      Loginmodel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Loginmodel.fromJson(Map<String, dynamic> json) => Loginmodel(
        mobile: json["mobile"],
        genNumb: json["gen_numb"],
        logTime: json["log_time"],
        ip: json["ip"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "gen_numb": genNumb,
        "log_time": logTime,
        "ip": ip,
        "location": location,
      };
}
