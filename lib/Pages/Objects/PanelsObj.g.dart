// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PanelsObj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanelsObj _$PanelsObjFromJson(Map json) {
  return PanelsObj(
    json['panelCode'] as String,
    json['panelPrice'] as String,
    json['height'] as String,
    json['width'] as String,
    json['type'] as String,
    json['desc2'] as String,
    json['size'] as String,
    json['isFree'] as bool
  );
}

Map<String, dynamic> _$PanelsObjToJson(PanelsObj instance) => <String, dynamic>{
      'panelCode': instance.panelCode,
      'panelPrice': instance.panelPrice,
      'height': instance.height,
      'width': instance.width,
      'type': instance.type,
      'desc2': instance.desc2,
      'size': instance.size,
      'isFree':instance.isFree
    };
