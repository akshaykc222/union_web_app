
import 'dart:core';
import 'package:json_annotation/json_annotation.dart';
part 'Measurement.g.dart';

@JsonSerializable(anyMap: true)
class Measurement{
  final String cm;
  final String m;
  final String inch;
  final String feet;

  Measurement( this.cm, this.m,  this.inch,  this.feet);
  factory Measurement.fromJson(Map<String,dynamic> json)=> _$MeasurementFromJson(json);
  Map<String,dynamic> toJson()=>_$MeasurementToJson(this);
}