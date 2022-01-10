import 'package:flutter/material.dart';
import 'package:isro_pedia/screens/WikiPage/customer_countries_screen.dart';
import 'package:isro_pedia/screens/WikiPage/spacecraft_screen.dart';

import 'centres_screen.dart';
import 'launchers_screen.dart';

String data =
    r"The Indian Space Research Organisation (ISRO) is the national space agency of India, headquartered in Bengaluru. It operates under the Department of Space (DOS) which is directly overseen by the Prime Minister of India, while Chairman of ISRO acts as executive of DOS as well. ISRO is the primary agency in India to perform tasks related to space based applications, space exploration and development of related technologies. It is one of six government space agencies in the world which possess full launch capabilities, deploy cryogenic engines, launch extra-terrestrial missions and operate large fleets of artificial satellites.";

class WikiPage extends StatelessWidget {
  const WikiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Text("ISRO", textScaleFactor: 3),
              const Divider(),
              const SizedBox(height: 5),
              Text(data, textScaleFactor: 1.5, textAlign: TextAlign.justify),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const Text("More About", textScaleFactor: 3),
              const SizedBox(height: 10),
              InfoBars(
                title: "Spacecrafts",
                color: Colors.blue,
                onClick: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SpacecraftsScreen()));
                },
              ),
              InfoBars(
                title: "Launchers",
                color: Colors.grey,
                onClick: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LaunchersScreen()));
                },
              ),
              InfoBars(
                title: "Customer Countries",
                color: Colors.redAccent,
                onClick: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CustomerCounteriesScreen()));
                },
              ),
              InfoBars(
                title: "Centers",
                color: Colors.orangeAccent,
                onClick: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CentresScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoBars extends StatelessWidget {
  final String title;
  final Color color;
  final Function() onClick;
  const InfoBars({
    Key? key,
    required this.title,
    required this.color,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Row(
        children: [
          Text(title, textScaleFactor: 2),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: onClick,
          )
        ],
      ),
    );
  }
}
