# *IMPORTANTE*
## /lib/env/host.dart
>Modificar ip del host a la ip de la maquina donde corre el servidor.
```js
class Host {
  static String getHost() {
    return '10.11.8.125';
  }
}
```
```markdown

## Estructura del Proyecto

```plaintext
/lib
  /env
    host.dart
  /screens
    alumnos_screen.dart
    aulas_screen.dart
    docentes_screen.dart
    grupos_screen.dart
    home_screen.dart
    import_data_screen.dart
    materias_screen.dart
    planes_de_estudio_screen.dart
    queries_screen.dart
  /widgets
    drawer_menu.dart
  main.dart
```

### /lib/env/host.dart
Este archivo contiene la configuración del host para la API. Define la IP local que se utilizará para las peticiones HTTP.
```dart
class Host {
  static String getHost() {
    return '10.11.8.125';
  }
}
```

### /lib/screens/home_screen.dart
La pantalla de inicio de la aplicación. Incluye un Drawer para la navegación a otras pantallas.
```dart
import 'package:flutter/material.dart';
import 'package:nosql_interfaz_de_prueba/widgets/drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoSQL Interfaz de Prueba'),
      ),
      drawer: DrawerMenu(),
      body: Center(
        child: Text('Bienvenido a la Interfaz de Prueba de NoSQL'),
      ),
    );
  }
}
```

### /lib/widgets/drawer_menu.dart
El Drawer para la navegación entre las diferentes pantallas de la aplicación.
```dart
import 'package:flutter/material.dart';
import 'package:nosql_interfaz_de_prueba/screens/import_data_screen.dart';
import 'package:nosql_interfaz_de_prueba/screens/queries_screen.dart';
import 'package:nosql_interfaz_de_prueba/screens/alumnos_screen.dart';
import 'package:nosql_interfaz_de_prueba/screens/docentes_screen.dart';
import 'package:nosql_interfaz_de_prueba/screens/materias_screen.dart';
import 'package:nosql_interfaz_de_prueba/screens/grupos_screen.dart';
import 'package:nosql_interfaz_de_prueba/screens/aulas_screen.dart';
import 'package:nosql_interfaz_de_prueba/screens/planes_de_estudio_screen.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Importar Datos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImportDataScreen()),
              );
            },
          ),
          // Resto de las opciones de navegación
        ],
      ),
    );
  }
}
```

### /lib/screens/import_data_screen.dart
Pantalla para importar datos de prueba en la base de datos. Realiza una petición HTTP POST.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nosql_interfaz_de_prueba/env/host.dart';

class ImportDataScreen extends StatelessWidget {
  Future<void> importData() async {
    final response = await http.post(Uri.parse('http://${Env.localIp}:3000/tecnm/importar-datos'));
    // Manejo de la respuesta
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Importar Datos'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: importData,
          child: Text('Importar Datos'),
        ),
      ),
    );
  }
}
```

### /lib/screens/queries_screen.dart
Pantalla para ejecutar consultas GET en la base de datos. Permite seleccionar una consulta y los parámetros necesarios.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nosql_interfaz_de_prueba/env/host.dart';

class QueriesScreen extends StatefulWidget {
  @override
  _QueriesScreenState createState() => _QueriesScreenState();
}

class _QueriesScreenState extends State<QueriesScreen> {
  // Variables y métodos para manejar las consultas y mostrar resultados
}

```

### /lib/screens/alumnos_screen.dart
Pantalla para gestionar la entidad "Alumnos". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nosql_interfaz_de_prueba/env/host.dart';

class AlumnosScreen extends StatefulWidget {
  @override
  _AlumnosScreenState createState() => _AlumnosScreenState();
}

class _AlumnosScreenState extends State<AlumnosScreen> {
  // Variables y métodos para manejar CRUD de Alumnos
}
```

### /lib/screens/docentes_screen.dart
Pantalla para gestionar la entidad "Docentes". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nosql_interfaz_de_prueba/env/host.dart';

class DocentesScreen extends StatefulWidget {
  @override
  _DocentesScreenState createState() => _DocentesScreenState();
}

class _DocentesScreenState extends State<DocentesScreen> {
  // Variables y métodos para manejar CRUD de Docentes
}
```

### /lib/screens/materias_screen.dart
Pantalla para gestionar la entidad "Materias". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nosql_interfaz_de_prueba/env/host.dart';

class MateriasScreen extends StatefulWidget {
  @override
  _MateriasScreenState createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  // Variables y métodos para manejar CRUD de Materias
}
```

### /lib/screens/grupos_screen.dart
Pantalla para gestionar la entidad "Grupos". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nosql_interfaz_de_prueba/env/host.dart';

class GruposScreen extends StatefulWidget {
  @override
  _GruposScreenState createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  // Variables y métodos para manejar CRUD de Grupos
}
```

### /lib/screens/aulas_screen.dart
Pantalla para gestionar la entidad "Aulas". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nosql_interfaz_de_prueba/env/host.dart';

class AulasScreen extends StatefulWidget {
  @override
  _AulasScreenState createState() => _AulasScreenState();
}

class _AulasScreenState extends State<AulasScreen> {
  // Variables y métodos para manejar CRUD de Aulas
}
```

### /lib/screens/planes_de_estudio_screen.dart
Pantalla para gestionar la entidad "Planes de Estudio". Permite realizar operaciones CRUD.
```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nosql_interfaz_de_prueba/env/host.dart';

class PlanesDeEstudioScreen extends StatefulWidget {
  @override
  _PlanesDeEstudioScreenState createState() => _PlanesDeEstudioScreenState();
}

class _PlanesDeEstudioScreenState extends State<PlanesDeEstudioScreen> {
  // Variables y métodos para manejar CRUD de Planes de Estudio
}
```

### main.dart
Punto de entrada de la aplicación. Configura el MaterialApp y establece la pantalla de inicio.
```dart
import 'package:flutter/material.dart';
import 'package:nosql_interfaz_de_prueba/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoSQL Interfaz de Prueba',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
```