import 'referencia_api.dart';
import 'package:agronova_app/models/tipo_tarea.dart';

class TipoTareaApi extends ReferenciaApi<TipoTarea> {
  TipoTareaApi()
    : super(endpoint: '/catalogos/tipos-tarea', fromMap: TipoTarea.fromMap);
}
