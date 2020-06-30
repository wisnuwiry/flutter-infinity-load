import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../photo_repository.dart';
import '../photos_model.dart';

part 'infinite_load_event.dart';
part 'infinite_load_state.dart';

class InfiniteLoadBloc extends Bloc<InfiniteLoadEvent, InfiniteLoadState> {
  PhotoRepository _repository = PhotoRepository();
  List<PhotosModel> _data = [];
  int _currentLenght;
  bool _isLastPage;

  @override
  InfiniteLoadState get initialState => InfiniteLoadLoading();

  @override
  Stream<Transition<InfiniteLoadEvent, InfiniteLoadState>> transformEvents(
      Stream<InfiniteLoadEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<InfiniteLoadState> mapEventToState(
    InfiniteLoadEvent event,
  ) async* {
    if (event is GetInfiniteLoad) {
      yield* _mapEventToStateInfiniteLoad(10);
    } else if (event is GetMoreInfiniteLoad) {
      yield* _mapEventToStateInfiniteLoad(event.start, event.limit);
    }
  }

  Stream<InfiniteLoadState> _mapEventToStateInfiniteLoad(int start,
      [int limit]) async* {
    try {
      if (state is InfiniteLoadLoaded) {
        _data = (state as InfiniteLoadLoaded).data;
        _currentLenght = (state as InfiniteLoadLoaded).count;
      }

      if (_currentLenght != null) {
        yield InfiniteLoadMoreLoading();
      } else {
        yield InfiniteLoadLoading();
      }

      if (_currentLenght == null || _isLastPage == null || !_isLastPage) {
        final reqData = await _repository.getPhotos(start: start, limit: limit);

        if (reqData.isNotEmpty) {
          _data.addAll(reqData);
          if (_currentLenght != null) {
            _currentLenght += reqData.length;
          } else {
            _currentLenght = reqData.length;
          }
        } else {
          _isLastPage = true;
        }
      }
      yield InfiniteLoadLoaded(data: _data, count: _currentLenght);
    } catch (e) {
      yield InfiniteLoadError();
    }
  }
}
