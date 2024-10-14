import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pokemon_provider.dart';
import 'screens/pokemon_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PokemonProvider(),
      child: MaterialApp(
        title: 'Pokémon App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PokemonListScreen(),
      ),
    );
  }
}
