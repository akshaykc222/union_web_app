import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
part 'Gates.g.dart';
@JsonSerializable()
class Gates{
  final String gate_code;
  final String gate_desc;
  final double gate_cost;
  final String gate_img;

  Gates(this.gate_code, this.gate_desc, this.gate_cost, this.gate_img);
  factory Gates.fromJson(Map<String,dynamic> json)=>_$GatesFromJson(json);
  Map<String,dynamic> toJson()=>_$GatesToJson(this);
}