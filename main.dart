import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

final Color marfil = Color.fromRGBO(255, 255, 240, 1.0);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SISTEMA DE RIEGO AUTOMATIZADO',
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            title: Center(
              child: Text(
                'SISTEMA DE RIEGO AUTOMATIZADO',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.green,
          ),
        ),
        body: CustomBody(),
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
  final ScrollController _scrollController = ScrollController();

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
          top: 20,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Image.asset(
                'assets/logo.jpg',
                width: 180,
                height: 180,
              ),
              SizedBox(height: 10), // Adjusted height
              DateTimeSection(), // Moved up to align with the logo image
            ],
          ),
        ),
        Positioned(
          top: 20,
          left: 0,
          child: CustomPopupMenu(scrollController: _scrollController),
        ),
        Positioned(
          top: 230, // Adjusted top position for sections
          left: 0,
          right: 0,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomSection(title: 'Sección 1', content: 'Se muestran las lecturas actuales del sensor'),
                SizedBox(height: 20),
                CustomSection(title: 'Sección 2', content: 'Se muestra el historial de mediciones y se grafica'),
                SizedBox(height: 20),
                CustomSection(title: 'Sección 3', content: 'Se muestran los parámetros disponibles para configurar por el usuari-o'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomPopupMenu extends StatelessWidget {
  final ScrollController scrollController;

  const CustomPopupMenu({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 16, 0, 8), // Adjusted padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomMenuItem(
            icon: Icons.info,
            title: 'Información en tiempo real',
            onPressed: () {
              // Desplazar al inicio de la sección 1
              scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
          ),
          SizedBox(
            height: 20,
            child: Container(color: marfil), // SizedBox with marfil background color
          ),
          CustomMenuItem(
            icon: Icons.bar_chart,
            title: 'Historial de registros',
            onPressed: () {
              // Desplazar al inicio de la sección 2
              scrollController.animateTo(220, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
          ),
          SizedBox(
            height: 20,
            child: Container(color: marfil), // SizedBox with marfil background color
          ),
          CustomMenuItem(
            icon: Icons.settings,
            title: 'Configuración de parámetros',
            onPressed: () {
              // Desplazar al inicio de la sección 3
              scrollController.animateTo(440, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
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
    Key? key,
    required this.icon,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }
}


class DateTimeSection extends StatelessWidget {
  const DateTimeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha y Hora Actual',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Fecha: $formattedDate\nHora: $formattedTime',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class CustomSection extends StatelessWidget {
  final String title;
  final String content;

  const CustomSection({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
