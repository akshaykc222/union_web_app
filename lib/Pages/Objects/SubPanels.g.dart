// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubPanels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubPanels _$SubPanelsFromJson(Map json) {
  return SubPanels(
    json['imagePosition'] as int,
    json['panelCost'] as int,
    json['panelName'] as String,
  );
}

Map<String, dynamic> _$SubPanelsToJson(SubPanels instance) => <String, dynamic>{
      'imagePosition': instance.imagePosition,
      'panelCost': instance.panelCost,
      'panelName': instance.panelName,
    };
