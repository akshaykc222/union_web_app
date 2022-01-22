// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomerObj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerObj _$CustomerObjFromJson(Map json) {
  return CustomerObj(
    json['address'] as String,
    json['agent'] as String,
    json['altPhone'] as String,
    json['name'] as String,
    json['phone'] as String,
    json['pinCode'] as String,
    json['district'] as String,
  );
}

Map<String, dynamic> _$CustomerObjToJson(CustomerObj instance) =>
    <String, dynamic>{
      'address': instance.address,
      'agent': instance.agent,
      'altPhone': instance.altPhone,
      'name': instance.name,
      'phone': instance.phone,
      'pinCode': instance.pinCode,
      'district': instance.district,
    };
