import 'package:equatable/equatable.dart';

// Extends Equatable, which provides support for equality checks
class Ingredient extends Equatable {
  // id and recipeId not final so they can be changed later.
  int? id;
  int? recipeId;
  final String? name;
  final double? weight;

  Ingredient({this.id, this.recipeId, this.name, this.weight});

  // Equatable uses the props value to know what fields to compare when doing
  // equality checks
  @override
  List<Object?> get props => [recipeId, name, weight];
}
