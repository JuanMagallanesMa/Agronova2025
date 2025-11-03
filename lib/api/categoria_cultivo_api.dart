import 'referencia_api.dart';
import 'package:agronova_app/models/categoria_cultivo.dart';

class CategoriaCultivoApi extends ReferenciaApi<CategoriaCultivo> {
  CategoriaCultivoApi()
    : super(endpoint: '/categorias-cultivo', fromMap: CategoriaCultivo.fromMap);
}
