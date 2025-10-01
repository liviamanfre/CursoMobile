import 'dart:io';

import 'package:cine_favorite/controllers/favorite_movie_controller.dart';
import 'package:cine_favorite/models/favorite_movie.dart';
import 'package:cine_favorite/views/search_movie_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final _favMovieController = FavoriteMovieController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Filmes Favoritos"),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      // a construção da tela vai depender do conteudo da lista de favoritos
      body: StreamBuilder<List<FavoriteMovie>>(
        // buscar a lista de favoritos no firebasfirestore
        stream: _favMovieController.getFavoriteMovies(),
        builder: (context, snapshot) {
          // se deu erro ao carregar a lista
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao Carregar a Lista de Favoritos"));
          }
          // enquanto esta conectando com o firStore
          if (!snapshot.hasData) {
            // veririca se os dados estão vazios e ! transforma em booleana
            return Center(child: CircularProgressIndicator());
          }
          // quando a lista estiver vazia
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Text("Nenhum filme adicionado aos favoritos."),
            );
          }
          // construção da lista
          final favoriteMovies = snapshot.data!;
          return Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // remover favorito com long press
                      Expanded(
                        child: GestureDetector(
                          onLongPress: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Remover filme"),
                                content: Text(
                                  "Deseja remover '${movie.title}' dos favoritos?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text("Remover"),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              _favMovieController.removeFavoriteMovie(movie.id);
                            }
                          },
                          child: Image.file(
                            File(movie.posterPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(movie.title, textAlign: TextAlign.center),
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (starIndex) {
                            final starFilled = starIndex < movie.rating;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  movie.rating = starIndex + 1.0;
                                });
                                _favMovieController.updateMovieRating(
                                  movie.id,
                                  movie.rating,
                                );
                              },
                              child: Icon(
                                starFilled ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 28,
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchMovieView()),
        ),
        child: Icon(Icons.search),
      ),
    );
  }
}