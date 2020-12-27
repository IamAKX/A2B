part of 'menulist_bloc.dart';

abstract class MenulistEvent extends Equatable {
  const MenulistEvent();
}

class FetchHomeData extends MenulistEvent {
  int categoryID;
  FetchHomeData(this.categoryID) : super();

  int get getStoreKey => categoryID;

  @override
  List<Object> get props => [categoryID];
}
