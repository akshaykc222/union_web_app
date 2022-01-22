
import 'package:json_annotation/json_annotation.dart';
part 'SubPanels.g.dart';
@JsonSerializable(explicitToJson: true,anyMap: true)
class SubPanels{
  final int imagePosition;
  final int panelCost;
  final String panelName;

  SubPanels( this.imagePosition,  this.panelCost,  this.panelName);
  factory SubPanels.fromJson(Map<String,dynamic> json) => _$SubPanelsFromJson(json);
  Map<String, dynamic> toJson()=>_$SubPanelsToJson(this);
}