import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

const Color marfil = Color.fromRGBO(255, 255, 240, 1.0);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'SISTEMA DE RIEGO AUTOMATIZADO',
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'SISTEMA DE RIEGO AUTOMATIZADO',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
              backgroundColor: Colors.green,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(140), // Ajusta según sea necesario
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.asset(
                  'assets/logo.jpg',
                  width: 100, // Ajusta el tamaño del logo según necesites
                  height: 100,
                  fit: BoxFit.contain, // Ajustar la imagen dentro del contenedor
                ),
              ),
            ),
          ),
          body: const CustomBody(),
        ),
      );
    }
  }

class CustomBody extends StatefulWidget {
  const CustomBody({Key? key}) : super(key: key);

  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  String? selectedSection;
  late List<String> lines;

  @override
  void initState() {
    super.initState();
    lines = []; // Inicializar la lista vacía al inicio
    _readFile();
  }

  Future<void> _readFile() async {
    try {
      final File file = File('mediciones.txt');
      if (await file.exists()) {
        lines = await file.readAsLines();
        setState(() {}); // Actualizar UI después de leer el archivo
      } else {
        print('El archivo no existe.');
      }
    } catch (e) {
      print('Error al leer el archivo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: marfil,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
          top: 120,
          left: 20,
          child: CustomPopupMenu(
            onItemSelected: (section) {
              setState(() {
                selectedSection = section;
              });
            },
          ),
        ),
        if (selectedSection != null)
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  if (selectedSection == 'Información en tiempo real')
                    FutureBuilder(
                      future: leerArchivoRtdo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CustomSection(
                            title: 'Sección 1 - Mediciones',
                            content: Text(snapshot.data ?? 'No se encontraron mediciones para hoy.'),
                          );
                        }
                      },
                    ),
                  if (selectedSection == 'Historial de mediciones')
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Sección 2 - Historial de mediciones'),
                          const SizedBox(height: 20),
                          Text('Aquí va el contenido del historial de mediciones...'),
                        ],
                      ),
                    ),
                  if (selectedSection == 'Configuración de parámetros')
                    const ConfiguracionParametros(),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class CustomPopupMenu extends StatelessWidget {
  final Function(String) onItemSelected;

  const CustomPopupMenu({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomMenuItem(
            icon: Icons.info,
            title: 'Información en tiempo real',
            onPressed: () {
              onItemSelected('Información en tiempo real');
            },
          ),
          SizedBox(
            height: 20,
            child: Container(color: marfil),
          ),
          CustomMenuItem(
            icon: Icons.bar_chart,
            title: 'Historial de mediciones',
            onPressed: () {
              onItemSelected('Historial de mediciones');
            },
          ),
          SizedBox(
            height: 20,
            child: Container(color: marfil),
          ),
          CustomMenuItem(
            icon: Icons.settings,
            title: 'Configuración de parámetros',
            onPressed: () {
              onItemSelected('Configuración de parámetros');
            },
          ),
        ],
      ),
    );
  }
}

class CustomMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const CustomMenuItem({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }
}

class CustomSection extends StatelessWidget {
  final String title;
  final Widget content;

  const CustomSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}

class ConfiguracionParametros extends StatefulWidget {
  const ConfiguracionParametros({Key? key}) : super(key: key);

  @override
  _ConfiguracionParametrosState createState() => _ConfiguracionParametrosState();
}

class _ConfiguracionParametrosState extends State<ConfiguracionParametros> {
  late TextEditingController umbralController;
  late TextEditingController tiempoBombaController;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    umbralController = TextEditingController();
    tiempoBombaController = TextEditingController();
    cargarConfiguracion();
  }

  @override
  void dispose() {
    umbralController.dispose();
    tiempoBombaController.dispose();
    super.dispose();
  }

  Future<void> cargarConfiguracion() async {
    try {
      final File file = File('config.txt');
      List<String> contents = await file.readAsLines();
      setState(() {
        umbralController.text = contents.isNotEmpty ? contents[0] : '';
        tiempoBombaController.text = contents.length > 1 ? contents[1] : '';
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al cargar la configuración: $e';
      });
    }
  }

  Future<void> guardarConfiguracion() async {
    try {
      final File file = File('config.txt');
      await file.writeAsString('${umbralController.text}\n${tiempoBombaController.text}');
      setState(() {
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error al guardar la configuración: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorMessage != null) Text(errorMessage!, style: TextStyle(color: Colors.red)),
        Text(
          'Parámetros Actuales:',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: umbralController,
          decoration: InputDecoration(labelText: 'Umbral de Humedad (%)'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: tiempoBombaController,
          decoration: InputDecoration(labelText: 'Tiempo de riego (en minutos)'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: guardarConfiguracion,
          child: const Text('Guardar Cambios'),
        ),
      ],
    );
  }
}

Future<String> leerArchivoRtdo() async {
  try {
    final File file = File('mediciones.txt');
    if (await file.exists()) {
      List<String> lines = await file.readAsLines();

      // Variables para almacenar los datos procesados
      List<String> column1 = [];
      List<String> column3 = [];

      // Obtener la fecha actual en formato 'dd/MM/yyyy'
      String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

      // Procesar cada línea del archivo
      for (String line in lines) {
        List<String> columns = line.split('|'); // Separar por el carácter '|'

        // Verificar si la línea tiene al menos 3 partes y la fecha coincide con la actual
        if (columns.length >= 3 && columns[0].startsWith(currentDate)) {
          column1.add(columns[0]); // Columna 1 (fecha y hora)
          column3.add(columns[2]); // Columna 3 (Humedad del suelo)
        }
      }

      // Si no se encontraron mediciones para hoy
      if (column1.isEmpty) {
        return 'No se encontraron mediciones para hoy.';
      }

      // Construir el resultado con títulos y datos procesados
      String result = 'FECHA Y HORA          \tHUMEDAD DEL SUELO(%)\n'; // Títulos
      for (int i = 0; i < column1.length; i++) {
        result += '${column1[i]}\t       ${column3[i]}\n'; // Datos
      }

      // Retornar el resultado junto con el mensaje de éxito
      return 'Se encontraron mediciones para hoy.\n\n$result';
    } else {
      return 'El archivo no existe.';
    }
  } catch (e) {
    return 'Error al leer el archivo: $e';
  }
}
