import 'package:json_annotation/json_annotation.dart';
part 'PanelsObj.g.dart';
@JsonSerializable(anyMap: true)
class PanelsObj{
  final String panelCode;
  final String panelPrice;
  final String height;
  final String width;
  final String type;
  final String desc2;
  final String size;
  final bool isFree;
  PanelsObj(this.panelCode, this.panelPrice, this.height, this.width, this.type, this.desc2, this.size, this.isFree);
  factory PanelsObj.fromJson(Map<String,dynamic> json)=>_$PanelsObjFromJson(json);
  Map<String,dynamic> toJson()=>_$PanelsObjToJson(this);
}