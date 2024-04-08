import 'package:data_connection_checker_tv/data_connection_checker.dart';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mapp_clean_architecture/core/constants/constants.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon/business/entities/pokemon_entity.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/business/entities/pokemon_image_entity.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/business/usecases/get_pokemon_image.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/data/datasources/pokemon_image_local_data_source.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/data/datasources/pokemon_image_remote_data_source.dart';
import 'package:flutter_mapp_clean_architecture/features/pokemon_image/data/repositories/pokemon_image_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class PokemonImageProvider extends ChangeNotifier {
  PokemonImageEntity? pokemonImage;
  Failure? failure;

  PokemonImageProvider({
    this.pokemonImage,
    this.failure,
  });

  void eitherFailureOrPokemonImage(
      {required PokemonEntity pokemonEntity,}) async {
    PokemonImageRepositoryImpl repository = PokemonImageRepositoryImpl(
      remoteDataSource: PokemonImageRemoteDataSourceImpl(
        dio: Dio(),
      ),
      localDataSource: PokemonImageLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    String imageUrl = isShiny
        ? pokemonEntity.sprites.other.officialArtwork.frontShiny
        : pokemonEntity.sprites.other.officialArtwork.frontDefault;

    final failureOrPokemonImage =
        await GetPokemonImage(pokemonImageRepository: repository).call(
      pokemonImageParams: PokemonImageParams(
        name: pokemonEntity.name,
        imageUrl: imageUrl,
      ),
    );

    failureOrPokemonImage.fold(
      (Failure newFailure) {
        pokemonImage = null;
        failure = newFailure;
        notifyListeners();
      },
      (PokemonImageEntity newPokemonImage) {
        pokemonImage = newPokemonImage;
        failure = null;
        notifyListeners();
      },
    );
  }
}
