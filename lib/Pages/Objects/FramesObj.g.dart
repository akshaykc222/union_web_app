// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FramesObj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FramesObj _$FramesObjFromJson(Map json) {
  return FramesObj(

    json['id'] as String,
    json['frameCode'] as String,
    Measurement.fromJson(Map<String, dynamic>.from(json['height'] as Map)),
    Measurement.fromJson(Map<String, dynamic>.from(json['width'] as Map)),
    json['frameOuter'] as String,
    json['frameInner'] as String,
    json['cost'] as String,
    json['is300'] as bool,
    json['is500'] as bool,
    json['is1200'] as bool,
    json['panels'] as String,
    json['isFree'] as bool
  );
}

Map<String, dynamic> _$FramesObjToJson(FramesObj instance) => <String, dynamic>{
      'id': instance.id,
      'frameCode': instance.frameCode,
      'height': instance.height.toJson(),
      'width': instance.width.toJson(),
      'frameOuter': instance.frameOuter,
      'frameInner': instance.frameInner,
      'cost': instance.cost,
      'is300': instance.is300,
      'is500': instance.is500,
      'is1200': instance.is1200,
      'panels': instance.panels,
      'isFree':instance.isFree
    };
