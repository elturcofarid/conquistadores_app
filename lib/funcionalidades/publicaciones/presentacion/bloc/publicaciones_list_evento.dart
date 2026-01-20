import 'package:equatable/equatable.dart';

abstract class PublicacionesListEvento extends Equatable {
  const PublicacionesListEvento();

  @override
  List<Object?> get props => [];
}

class CargarPublicaciones extends PublicacionesListEvento {
  final int page;
  final int size;

  const CargarPublicaciones({this.page = 0, this.size = 20});

  @override
  List<Object?> get props => [page, size];
}

class RefrescarPublicaciones extends PublicacionesListEvento {}