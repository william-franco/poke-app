import 'package:poke_app/src/features/pokemons/domain/domain.dart';

class EvolutionModel extends EvolutionEntity {
  EvolutionModel({super.number, super.name});

  factory EvolutionModel.fromJson(Map<String, dynamic> json) =>
      EvolutionModel(number: json['num'], name: json['name']);

  Map<String, dynamic> toJson() => {'num': number, 'name': name};
}
