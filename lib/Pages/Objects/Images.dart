
import 'package:json_annotation/json_annotation.dart';
part 'Images.g.dart';

@JsonSerializable(anyMap: true)
class Images{
  final String img;
  final String name;

  Images(this.img, this.name);
  factory Images.fromJson(Map<String,dynamic> json)=> _$ImagesFromJson(json);
  Map<String,dynamic> toJson()=>_$ImagesToJson(this);
}

