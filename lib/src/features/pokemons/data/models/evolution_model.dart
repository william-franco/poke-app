import 'package:poke_app/src/features/pokemons/domain/entities/evolution_entity.dart';

class EvolutionModel extends EvolutionEntity {
  @override
  final String? num;
  @override
  final String? name;

  EvolutionModel({this.num, this.name});

  factory EvolutionModel.fromJson(Map<String, dynamic> json) =>
      EvolutionModel(num: json['num'], name: json['name']);

  Map<String, dynamic> toJson() => {'num': num, 'name': name};
}
