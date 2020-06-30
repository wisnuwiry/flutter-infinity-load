import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'bloc/infinite_load_bloc.dart';
import 'photo_item.dart';
import 'photos_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocProvider(
          create: (context) => InfiniteLoadBloc()..add(GetInfiniteLoad()),
          child: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InfiniteLoadBloc _bloc;
  int _currentLenght;
  List<PhotosModel> _data = [];

  void _loadMoreData() {
    _bloc.add(GetMoreInfiniteLoad(start: _currentLenght, limit: 10));
  }

  @override
  void initState() {
    _bloc = BlocProvider.of<InfiniteLoadBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Load ScrollView'),
      ),
      body: BlocBuilder<InfiniteLoadBloc, InfiniteLoadState>(
        builder: (context, state) {
          if (state is InfiniteLoadLoaded || state is InfiniteLoadMoreLoading) {
            if (state is InfiniteLoadLoaded) {
              _data = state.data;
              _currentLenght = state.count;
            }
            return _buildListPhotos(state);
          } else if (state is InfiniteLoadLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Text('Error');
          }
        },
      ),
    );
  }

  Widget _buildListPhotos(InfiniteLoadState state) {
    return LazyLoadScrollView(
      child: ListView(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: _data.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) {
                return PhotoItem(data: _data[i]);
              }),
          // Loading indicator more load data
          (state is InfiniteLoadMoreLoading)
              ? Center(child: CircularProgressIndicator())
              : SizedBox(),
        ],
      ),
      onEndOfPage: _loadMoreData,
    );
  }
}
