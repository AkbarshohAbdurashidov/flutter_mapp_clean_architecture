import 'package:dartz/dartz.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/business/repositories/pokemon_image_repository.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../entities/pokemon_image_entity.dart';

class GetPokemonImage {
  final PokemonImageRepository pokemonImageRepository;

  GetPokemonImage({required this.pokemonImageRepository});

  Future<Either<Failure, PokemonImageEntity>> call({
    required PokemonImageParams pokemonImageParams,
  }) async {
    return await pokemonImageRepository.getPokemonImage(pokemonImageParams: pokemonImageParams);
  }
}
