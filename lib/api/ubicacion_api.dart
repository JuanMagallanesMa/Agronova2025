import 'referencia_api.dart';
import 'package:agronova_app/models/ubicacion.dart';

class UbicacionApi extends ReferenciaApi<Ubicacion> {
  UbicacionApi() : super(endpoint: '/catalogos/ubicaciones', fromMap: Ubicacion.fromMap);
}
