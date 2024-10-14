import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  final String apiUrl = 'http://192.168.100.88:3000/pokemons';

  Future<List<Pokemon>> fetchPokemons(int page,
      {String? name, String? type}) async {
    var url = Uri.parse('$apiUrl?page=$page');
    if (name != null) url = Uri.parse('$apiUrl?page=$page&name=$name');
    if (type != null) url = Uri.parse('$apiUrl?page=$page&type=$type');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List pokemons = data['pokemons'];
      return pokemons.map((pokemon) => Pokemon.fromJson(pokemon)).toList();
    } else {
      throw Exception('Error al cargar pokemones');
    }
  }

  Future<void> capturePokemon(int pokemonId) async {
    var url = Uri.parse('$apiUrl/$pokemonId/capture');
    final response = await http.post(url);
    if (response.statusCode != 200) {
      throw Exception('Error al capturar el Pokémon');
    }
  }

  Future<void> releasePokemon(int pokemonId) async {
    var url = Uri.parse('$apiUrl/$pokemonId');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Error al liberar el Pokémon');
    }
  }

  Future<List<Pokemon>> fetchCapturedPokemons() async {
    var url = Uri.parse('$apiUrl/captured');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List pokemons = jsonDecode(response.body);
      return pokemons.map((pokemon) => Pokemon.fromJson(pokemon)).toList();
    } else {
      throw Exception('Error al cargar los pokemones capturados');
    }
  }
}
