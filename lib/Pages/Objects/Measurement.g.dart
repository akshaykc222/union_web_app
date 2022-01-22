// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Measurement _$MeasurementFromJson(Map json) {
  return Measurement(
    json['cm'] as String,
    json['m'] as String,
    json['inch'] as String,
    json['feet'] as String,
  );
}

Map<String, dynamic> _$MeasurementToJson(Measurement instance) =>
    <String, dynamic>{
      'cm': instance.cm,
      'm': instance.m,
      'inch': instance.inch,
      'feet': instance.feet,
    };
