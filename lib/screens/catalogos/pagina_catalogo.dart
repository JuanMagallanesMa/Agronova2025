// lib/screens/catalogos/pagina_catalogo.dart (CORREGIDO)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agronova_app/models/referencia_base.dart';
import 'package:agronova_app/widgets/layout/main_scaffold.dart';
import 'package:agronova_app/widgets/shared/loading_spinner.dart';
import 'package:agronova_app/widgets/shared/delete_dialog.dart';
import 'registro_catalogo.dart';
import 'package:agronova_app/core/provider_interfaces.dart';

class PaginaCatalogo<T extends ReferenciaBase, P extends IReferenciaProvider<T>>
    extends StatefulWidget {
  final String title;
  final T Function(ReferenciaBase) itemFactory;

  const PaginaCatalogo({
    super.key,
    required this.title,
    required this.itemFactory,
  });

  @override
  State<PaginaCatalogo<T, P>> createState() => _PaginaCatalogoState<T, P>();
}

class _PaginaCatalogoState<
  T extends ReferenciaBase,
  P extends IReferenciaProvider<T>
>
    extends State<PaginaCatalogo<T, P>> {
  IReferenciaProvider<T> _getProvider(
    BuildContext context, {
    bool listen = false,
  }) {
    return Provider.of<P>(context, listen: listen) as IReferenciaProvider<T>;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        _getProvider(context, listen: false).fetchAll();
      }
    });
  }

  void _navigateToRegistro([T? item]) {
    final provider = _getProvider(context, listen: false);

    Future<void> onSave(ReferenciaBase itemToSave) async {
      // Convertir ReferenciaBase a T usando el factory
      final typedItem = widget.itemFactory(itemToSave);

      final isEditing = typedItem.id!.isNotEmpty;
      if (isEditing) {
        await provider.update(typedItem);
      } else {
        await provider.add(typedItem);
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistroCatalogo<T>(
          title: widget.title,
          item: item,
          onSave: onSave,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, T item) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Inactivar ${widget.title}',
        content:
            '¿Está seguro que desea inactivar "${item.nombre}"? Se mantendrá en el historial pero no estará disponible para nuevos registros.',
        onConfirm: () {
          _getProvider(context, listen: false).deleteLogico(item.id!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = _getProvider(context, listen: true);
    final items = provider.items;
    final isLoading = provider.isLoading;

    return MainScaffold(
      title: 'Catálogo de ${widget.title}',
      trailingAppBar: IconButton(
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _navigateToRegistro(),
      ),
      body: isLoading
          ? const LoadingSpinner()
          : items.isEmpty
          ? Center(child: Text('No hay ${widget.title}s activos.'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final item = items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      item.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('ID: ${item.id}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _navigateToRegistro(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteDialog(context, item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
