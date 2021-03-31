import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieapp/home/movie_service.dart';
import 'package:movieapp/home/movies_exception.dart';
import 'package:riverpod/riverpod.dart';

import 'movie.dart';

int pageNumber = 1;

final MovieFutureProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  ref.maintainState = true;
  //print("PAGINA: $pageNumber");
  final movieService = ref.read(movieServiceProvider);
  final movies = await movieService.getMovies(pageNumber);
  return movies;
});

class MyHomePage extends ConsumerWidget {
/*  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
*/
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Movie APP - Página $pageNumber'),
        ),
        /*      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              
            ],
          ),
        ),*/
        body: watch(MovieFutureProvider).when(
            error: (e, s) {
              if (e is MoviesException) {
                return _ErrorBody(message: e.message);
              }
              return _ErrorBody(
                  message: "Oops something failed. - $pageNumber");
            },
            loading: () => Center(child: CircularProgressIndicator()),
            data: (movies) {
              return RefreshIndicator(
                onRefresh: () {
                  return context.refresh(MovieFutureProvider);
                },
                child: GridView.extent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                  children:
                      movies.map((movie) => _MovieBox(movie: movie)).toList(),
                ),
              );
            }),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            child: Icon(Icons.remove),
            onPressed: () {
              if (pageNumber > 1) {
                pageNumber = pageNumber == 1 ? 1 : pageNumber - 1;
                return context.refresh(MovieFutureProvider);
              }
            },
            heroTag: null,
            backgroundColor: pageNumber > 1 ? Colors.red : Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              pageNumber++;
              return context.refresh(MovieFutureProvider);
            },
            heroTag: null,
            backgroundColor: Colors.blue,
          )
        ]));
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => context.refresh(MovieFutureProvider),
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}

class _MovieBox extends StatelessWidget {
  final Movie movie;

  const _MovieBox({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          movie.fullImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _FrontBanner(text: movie.title),
        ),
      ],
    );
  }
}

class _FrontBanner extends StatelessWidget {
  const _FrontBanner({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          height: 60,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
