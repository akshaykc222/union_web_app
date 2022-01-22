
import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
import 'package:union_web_app/Pages/Objects/Measurement.dart';
part 'FramesObj.g.dart';

@JsonSerializable(explicitToJson: true,anyMap: true)
class FramesObj{
  final String id;
  final String frameCode;
  final Measurement height;
  final Measurement width;
  final String frameOuter;
  final String frameInner;
  final String cost;
  final bool is300;
  final bool is500;
  final bool is1200;
  final String panels;
  final bool isFree;
  FramesObj( this.id, this.frameCode, this.height,  this.width, this.frameOuter,  this.frameInner,  this.cost, this.is300, this.is500, this.is1200,  this.panels, this.isFree);
  factory FramesObj.fromJson(Map<String,dynamic> json) => _$FramesObjFromJson(json);
  Map<String, dynamic> toJson()=>_$FramesObjToJson(this);


}
