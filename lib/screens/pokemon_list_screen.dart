import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../services/pokemon_service.dart';

class PokemonListScreen extends StatefulWidget {
  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  int currentPage = 1;
  int totalPages = 8;
  List<Pokemon> pokemons = [];
  bool isLoading = false;

  final PokemonService _pokemonService = PokemonService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  void _initializePage() async {
    await Provider.of<PokemonProvider>(context, listen: false)
        .syncCapturedPokemons();
    _fetchPokemons();
  }

  void _fetchPokemons() async {
    setState(() {
      isLoading = true;
    });

    try {
      var searchText = _searchController.text.trim();

      var fetchedPokemons = await _pokemonService.fetchPokemons(
        currentPage,
        name: searchText,
        type: searchText,
      );

      var capturedPokemons =
          Provider.of<PokemonProvider>(context, listen: false).capturedPokemons;

      setState(() {
        pokemons = fetchedPokemons.map((pokemon) {
          pokemon.captured =
              capturedPokemons.any((captured) => captured.id == pokemon.id);
          return pokemon;
        }).toList();
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  void _toggleCapture(Pokemon pokemon) async {
    var provider = Provider.of<PokemonProvider>(context, listen: false);
    var isCaptured = provider.isCaptured(pokemon);

    if (isCaptured) {
      await _pokemonService.releasePokemon(pokemon.id);
      provider.releasePokemon(pokemon);
    } else {
      await _pokemonService.capturePokemon(pokemon.id);
      provider.capturePokemon(pokemon);
    }

    setState(() {
      pokemon.captured = !isCaptured;
    });
  }

  void _goToNextPage() {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
        _fetchPokemons();
      });
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        _fetchPokemons();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var capturedPokemons =
        Provider.of<PokemonProvider>(context).capturedPokemons;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon List - Página $currentPage de $totalPages'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o tipo...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                _fetchPokemons();
              },
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: pokemons.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokemons[index];
                      bool isCaptured = pokemon.captured;

                      return ListTile(
                        leading: Image.network(pokemon.image),
                        title: Text(pokemon.name),
                        subtitle: Text('Types: ${pokemon.types}'),
                        trailing: isCaptured
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.add_circle_outline),
                        onTap: () {
                          _toggleCapture(pokemon);
                        },
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: currentPage > 1 ? _goToPreviousPage : null,
                      child: Text('Página anterior'),
                    ),
                    TextButton(
                      onPressed:
                          currentPage < totalPages ? _goToNextPage : null,
                      child: Text('Página siguiente'),
                    ),
                  ],
                ),
                if (capturedPokemons.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Pokemones Capturados (${capturedPokemons.length}/6)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          children: capturedPokemons.map((pokemon) {
                            return Chip(
                              avatar: Image.network(pokemon.image),
                              label: Text(pokemon.name),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
