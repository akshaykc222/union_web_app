
import 'package:json_annotation/json_annotation.dart';
part 'Register.g.dart';
@JsonSerializable(anyMap: true)
class Register{
 final String accountNum;
 final String address;
 final String adhar;
 final bool isApproved;
 final bool allowed;
 final String name;
 final String phone;
 final String referred;

  Register(this.accountNum, this.address, this.adhar, this.isApproved, this.name, this.phone, this.referred, this.allowed);
  factory Register.fromJson(Map<String,dynamic> json)=>_$RegisterFromJson(json);
  Map<String,dynamic> toJson()=>_$RegisterToJson(this);
}