import 'package:agronova_app/pagina_inicio.dart';
import 'package:agronova_app/providers/ia_provider.dart';
import 'package:agronova_app/screens/ia/asistente_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Importar todos los Providers
import 'package:agronova_app/providers/agricultor_provider.dart';
import 'package:agronova_app/providers/categoria_cultivo_provider.dart';
import 'package:agronova_app/providers/cultivo_provider.dart';
import 'package:agronova_app/providers/insumo_provider.dart';
import 'package:agronova_app/providers/producto_provider.dart';
import 'package:agronova_app/providers/tarea_provider.dart';
import 'package:agronova_app/providers/tipo_insumo_provider.dart';
import 'package:agronova_app/providers/tipo_tarea_provider.dart';
import 'package:agronova_app/providers/ubicacion_provider.dart';
import 'package:agronova_app/providers/venta_provider.dart';

// Importar todas las Páginas Principales
import 'package:agronova_app/screens/agricultores/pagina_agricultores.dart';
import 'package:agronova_app/screens/cultivos/pagina_cultivos.dart';
import 'package:agronova_app/screens/inventario/pagina_inventario.dart';
import 'package:agronova_app/screens/mercado/pagina_mercado.dart';
import 'package:agronova_app/screens/productos/pagina_productos.dart';
import 'package:agronova_app/screens/tareas/pagina_tareas.dart';

void main() async {
  // Asegura que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la localización para formatos de fecha (ej. 'es_CO')
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AppState());
}

// Este widget registra todos los providers en la parte superior del árbol
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providers de Módulos Principales
        ChangeNotifierProvider(create: (_) => AgricultorProvider()),
        ChangeNotifierProvider(create: (_) => CultivoProvider()),
        ChangeNotifierProvider(create: (_) => InsumoProvider()),
        ChangeNotifierProvider(create: (_) => ProductoProvider()),
        ChangeNotifierProvider(create: (_) => TareaProvider()),
        ChangeNotifierProvider(create: (_) => VentaProvider()),

        // Providers de Catálogos
        ChangeNotifierProvider(create: (_) => CategoriaCultivoProvider()),
        ChangeNotifierProvider(create: (_) => TipoInsumoProvider()),
        ChangeNotifierProvider(create: (_) => TipoTareaProvider()),
        ChangeNotifierProvider(create: (_) => UbicacionProvider()),
        // En MultiProvider:
        ChangeNotifierProvider(create: (_) => IaProvider()),
      ],
      child: const MyApp(),
    );
  }
}

// Este widget es la raíz de tu aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriGestor',
      debugShowCheckedModeBanner: false,

      // Definimos un tema visual para la app
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Verde oscuro para el tema
          primary: const Color(0xFF2E7D32), // Verde oscuro
          secondary: Colors.amber, // Color de acento
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
        ),

        // --- CORRECCIÓN ---
        // Se cambió CardTheme por CardThemeData
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // --- FIN CORRECCIÓN ---
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // --- Página de Inicio ---
      // Esta es la primera pantalla que verá el usuario
      home: const PaginaInicio(),

      // --- Rutas ---
      // Definimos todas las rutas nombradas para la navegación
      routes: {
        PaginaInicio.routeName: (ctx) => const PaginaInicio(),
        PaginaCultivos.routeName: (ctx) => const PaginaCultivos(),
        PaginaTareas.routeName: (ctx) => const PaginaTareas(),
        PaginaInventario.routeName: (ctx) => const PaginaInventario(),
        PaginaAgricultores.routeName: (ctx) => const PaginaAgricultores(),
        PaginaProductos.routeName: (ctx) => const PaginaProductos(),
        PaginaMercado.routeName: (ctx) => const PaginaMercado(),
        AsistenteScreen.routeName: (ctx) => AsistenteScreen(),
      },
    );
  }
}
