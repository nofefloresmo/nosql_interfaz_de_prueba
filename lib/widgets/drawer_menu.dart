import 'package:flutter/material.dart';
import '../screens/import_data_screen.dart';
import '../screens/queries_screen.dart';
import '../screens/alumnos_screen.dart';
import '../screens/materias_screen.dart';
import '../screens/docentes_screen.dart';
import '../screens/grupos_screen.dart';
import '../screens/aulas_screen.dart';
import '../screens/planes_de_estudio_screen.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('TecNM API'),
          ),
          ListTile(
            title: const Text('Importar todos los datos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImportDataScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Querys'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QueriesScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Alumnos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlumnosScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Docentes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DocentesScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Materias'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MateriasScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Grupos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GruposScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Aulas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AulasScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Planes de Estudio'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlanesDeEstudioScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
