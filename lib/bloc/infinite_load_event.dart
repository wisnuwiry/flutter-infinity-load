part of 'infinite_load_bloc.dart';

abstract class InfiniteLoadEvent extends Equatable {
  const InfiniteLoadEvent();

  @override
  List<Object> get props => [];
}

class GetInfiniteLoad extends InfiniteLoadEvent {}

class GetMoreInfiniteLoad extends InfiniteLoadEvent {
  final int start, limit;

  GetMoreInfiniteLoad({@required this.start, this.limit});

  @override
  List<Object> get props => [start, limit];
}
