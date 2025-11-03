import 'referencia_api.dart';
import 'package:agronova_app/models/tipo_insumo.dart';

class TipoInsumoApi extends ReferenciaApi<TipoInsumo> {
  TipoInsumoApi()
    : super(endpoint: '/tipos-insumo', fromMap: TipoInsumo.fromMap);
}
