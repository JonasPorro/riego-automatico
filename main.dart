import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:universal_html/html.dart' as html;
import 'package:dio/dio.dart';

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
                        textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.green,
                    bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(140),
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Image.asset(
                                'assets/logo.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
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
    Timer? _timer;

    @override
    void initState() {
        super.initState();
        lines = []; // Inicializo la lista vacía al inicio
        _readFile();

        // Configuro el temporizador para refrescar cada 5 segundos
        _timer = Timer.periodic(Duration(seconds: 5), (timer) {
            _readFile();
        });
    }

    @override
    void dispose() {
        _timer?.cancel(); // Cancelar el temporizador cuando se destruya el widget
        super.dispose();
    }


    Future<void> _readFile() async {
        try {
            final dio = Dio();

            //final response = await http.get(Uri.parse('http://localhost/web/mediciones.txt'));
            final response = await dio.get('http://ecoriegobase.local/web/mediciones.txt');
            if (response.statusCode == 200) {
                setState(() {
                    lines = response.data.split('\n');
                });
            } else {
                throw Exception('Error al obtener el archivo: ${response.statusCode}');
            }
        } catch (e) {
            throw Exception('Error al leer el archivo: $e');
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
                        top: 250,
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
                                        const HistorialDeMediciones(),
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
            final response = await http.get(Uri.parse('http://ecoriegobase.local/web/config.txt'));
            if (response.statusCode == 200) {
                List<String> contents = response.body.split('\n');
                setState(() {
                    umbralController.text = contents.isNotEmpty ? contents[0] : '';
                    tiempoBombaController.text = contents.length > 1 ? contents[1] : '';
                    errorMessage = null;
                });
            } else {
                setState(() {
                    errorMessage = 'Error al obtener el archivo: ${response.statusCode}';
                });
            }
        } catch (e) {
            setState(() {
                errorMessage = 'Error al leer el archivo: $e';
            });
        }
    }

    Future<void> guardarConfiguracion() async {

            final dio = Dio();
            try {
                // Construir el contenido del archivo config.txt
                String configData = '${umbralController.text}\n${tiempoBombaController.text}';

                // Crear los datos del formulario
                FormData formData = FormData.fromMap({
                    'config_data': configData,
                });

                // Enviar la solicitud POST al servidor PHP
                final response = await dio.post(
                    'http://ecoriegobase.local/web/upload.php',
                    data: formData,
                );

                if (response.statusCode == 200) {
                    print('Archivo modificado y subido exitosamente');
                } else {
                    print('Error al subir el archivo');
                }
            } catch (e) {
                print('Error: $e');
            }
    }

    @override
    Widget build(BuildContext context) {
        return CustomSection(
            title: 'Sección 3 - Configuración de parámetros',
            content: Column(
                children: [
                    TextField(
                        controller: umbralController,
                        decoration: const InputDecoration(labelText: 'Umbral de humedad'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                        controller: tiempoBombaController,
                        decoration: const InputDecoration(labelText: 'Tiempo de la bomba (minutos)'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: guardarConfiguracion,
                        child: const Text('Guardar Configuración'),
                    ),
                    if (errorMessage != null)
                        Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                        ),
                ],
            ),
        );
    }
}

class HistorialDeMediciones extends StatefulWidget {
    const HistorialDeMediciones({Key? key}) : super(key: key);

    @override
    _HistorialDeMedicionesState createState() => _HistorialDeMedicionesState();
}

class _HistorialDeMedicionesState extends State<HistorialDeMediciones> {
    late List<String> lines;
    late List<String> _xLabels;

    @override
    void initState() {
        super.initState();
        lines = [];
        _xLabels = [];
        _readFile();
    }

    Future<void> _readFile() async {
        try {
            final response = await http.get(
                Uri.parse('http://ecoriegobase.local/web/mediciones.txt'));
            if (response.statusCode == 200) {
                lines = response.body.split('\n');
                setState(() {});
            } else {
                throw Exception(
                    'Error al obtener el archivo: ${response.statusCode}');
            }
        } catch (e) {
            throw Exception('Error al leer el archivo: $e');
        }
    }

    @override
    Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Text('Sección 2 - Historial de mediciones'),
                const SizedBox(height: 20),
                if (lines.isNotEmpty) _buildLineChart(),
            ],
        );
    }

    Widget _buildLineChart() {
        List<FlSpot> spots = [];
        _xLabels.clear();
        for (int i = 1; i < lines.length; i++) {
            List<String> columns = lines[i].split('|');
            if (columns.length >= 3) {
                double x = i.toDouble();
                double y = double.tryParse(columns[2]) ?? double.nan;
                if (y.isFinite) {
                    spots.add(FlSpot(x, y));
                    _xLabels.add('${columns[0]}, ${columns[1]}');
                }
            }
        }

        // Invertir las listas para mostrar las fechas desde la más antigua a la más reciente
        spots = spots.reversed.toList();

        _xLabels = _xLabels.reversed.toList();

        return Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            child: LineChart(
                LineChartData(
                    minX: 1,
                    maxX: spots.isNotEmpty ? spots.length.toDouble() - 1 : 0,
                    minY: 0,
                    maxY: 100,
                    titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true, reservedSize: 40),
                        ),
                        bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 70,
                                getTitlesWidget: (double value,
                                    TitleMeta meta) {
                                    const style = TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                    );
                                    Widget text;
                                    if (value.toInt() >= 0 &&
                                        value.toInt() < _xLabels.length) {
                                        text = Text(_xLabels[value.toInt()],
                                            style: style);
                                    } else {
                                        text = const Text('', style: style);
                                    }
                                    return SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: RotatedBox(
                                            quarterTurns: 3,
                                            child: text,
                                        ),
                                    );
                                },
                            ),
                        ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                        LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 4,
                            belowBarData: BarAreaData(
                                show: true,
                                color: Colors.lightBlue.withOpacity(0.4),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}


Future<String?> leerArchivoRtdo() async {
    try {
        final response = await http.get(Uri.parse('http://ecoriegobase.local/web/mediciones.txt'));
        if (response.statusCode == 200) {
            return response.body;
        } else {
            return 'Error al obtener el archivo: ${response.statusCode}';
        }
    } catch (e) {
        return 'Error al leer el archivo: $e';
    }
}
