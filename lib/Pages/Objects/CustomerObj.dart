import 'package:json_annotation/json_annotation.dart';
part 'CustomerObj.g.dart';
@JsonSerializable(explicitToJson: true,anyMap: true)
class CustomerObj{
  final String address;
  final String agent;
  final String altPhone;
  final String name;
  final String phone;
  final String pinCode;
  final String district;
  CustomerObj(  this.address, this.agent, this.altPhone, this.name, this.phone, this.pinCode, this.district);
  factory CustomerObj.fromJson(Map<String,dynamic> json) => _$CustomerObjFromJson(json);
  Map<String, dynamic> toJson()=>_$CustomerObjToJson(this);
}