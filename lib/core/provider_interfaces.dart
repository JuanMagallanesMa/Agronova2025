// lib/core/provider_interfaces.dart
import 'package:agronova_app/models/referencia_base.dart';
import 'package:flutter/material.dart';

// ----------------------------------------------------
// Interfaces para el listado genérico de catálogos
// ----------------------------------------------------

// 1. Interfaz para obtener la lista de ítems
abstract interface class HasItems<T> {
  List<T> get items;
}

// 2. Interfaz para la funcionalidad de carga de datos
abstract interface class CanFetch {
  Future<void> fetchAll();
  bool get isLoading;
}

// 3. Interfaz para la función de adición
abstract interface class CanAdd<T> {
  Future<void> add(T item);
}

// 4. Interfaz para la función de actualización
abstract interface class CanUpdate<T> {
  Future<void> update(T item);
}

// 5. Interfaz para el borrado lógico
abstract interface class CanDeleteLogico {
  Future<void> deleteLogico(String id);
}

// Interfaz que todo Provider de catálogo debe implementar
// Esto asegura que cumplen con todas las funciones necesarias (CRUD + Fetch)
abstract class IReferenciaProvider<T extends ReferenciaBase> 
    extends ChangeNotifier
    implements HasItems<T>, CanFetch, CanAdd<T>, CanUpdate<T>, CanDeleteLogico {}

// Tipo genérico para la función de guardado (para registro_catalogo.dart)
typedef SaveFunction<T extends ReferenciaBase> = Future<void> Function(T item);