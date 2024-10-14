import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  List<Pokemon> _capturedPokemons = [];
  final PokemonService _pokemonService = PokemonService();

  List<Pokemon> get capturedPokemons => _capturedPokemons;

  bool isCaptured(Pokemon pokemon) {
    return _capturedPokemons.any((p) => p.id == pokemon.id);
  }

  void capturePokemon(Pokemon pokemon) {
    if (_capturedPokemons.length < 6) {
      _capturedPokemons.add(pokemon);
      notifyListeners();
    } else {
      _capturedPokemons.removeAt(0);
      _capturedPokemons.add(pokemon);
      notifyListeners();
    }
  }

  void releasePokemon(Pokemon pokemon) {
    _capturedPokemons.removeWhere((p) => p.id == pokemon.id);
    notifyListeners();
  }

  Future<void> syncCapturedPokemons() async {
    try {
      List<Pokemon> fetchedCapturedPokemons =
          await _pokemonService.fetchCapturedPokemons();
      _capturedPokemons = fetchedCapturedPokemons;
      notifyListeners();
    } catch (e) {
      print('Error al sincronizar los pokemones capturados: $e');
    }
  }
}
