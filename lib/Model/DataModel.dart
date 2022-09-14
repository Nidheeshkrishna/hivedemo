import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'DataModel.g.dart';

@freezed
@HiveType(typeId: 0)
class DataModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool complete;
  @HiveField(4)
  @Default(0)
  int qty;

  DataModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.complete,
      required this.qty});
}
