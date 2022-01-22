// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Gates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gates _$GatesFromJson(Map<String, dynamic> json) {
  return Gates(
    json['gate_code'] as String,
    json['gate_desc'] as String,
    (json['gate_cost'] as num).toDouble(),
    json['gate_img'] as String,
  );
}

Map<String, dynamic> _$GatesToJson(Gates instance) => <String, dynamic>{
      'gate_code': instance.gate_code,
      'gate_desc': instance.gate_desc,
      'gate_cost': instance.gate_cost,
      'gate_img': instance.gate_img,
    };
