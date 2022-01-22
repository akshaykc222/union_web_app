// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Register _$RegisterFromJson(Map json) {
  return Register(
    json['accountNum'] as String,
    json['address'] as String,
    json['adhar'] as String,
    json['isApproved'] as bool,
    json['name'] as String,
    json['phone'] as String,
    json['referred'] as String,
    json['allowed'] as bool,
  );
}

Map<String, dynamic> _$RegisterToJson(Register instance) => <String, dynamic>{
      'accountNum': instance.accountNum,
      'address': instance.address,
      'adhar': instance.adhar,
      'isApproved': instance.isApproved,
      'allowed': instance.allowed,
      'name': instance.name,
      'phone': instance.phone,
      'referred': instance.referred,
    };
