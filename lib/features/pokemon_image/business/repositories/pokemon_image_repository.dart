import 'package:dartz/dartz.dart';
import 'package:flutter_mapp_clean_architecture/core/params/params.dart';
import '../../../../core/errors/failure.dart';
import '../entities/pokemon_image_entity.dart';

abstract class PokemonImageRepository {
  Future<Either<Failure, PokemonImageEntity>> getPokemonImage({
    required PokemonImageParams pokemonImageParams,
  });
}
