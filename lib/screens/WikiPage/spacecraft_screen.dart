import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isro_pedia/helper/api.dart';
import '../../models/spacecrafts_model.dart';
import 'package:http/http.dart' as http;

class SpacecraftsScreen extends StatelessWidget {
  const SpacecraftsScreen({Key? key}) : super(key: key);

  Future<List<SpacecraftsModel>> fetchData() async {
    List<SpacecraftsModel> data = [];
    await http.get(Uri.parse(spacecrafts)).then((value) {
      if (value.statusCode == 200) {
        List res = jsonDecode(value.body)["spacecrafts"];

        for (var element in res) {
          data.add(SpacecraftsModel(element["name"].toString()));
        }
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: FutureBuilder(
          future: fetchData(),
          builder: (ctx, AsyncSnapshot<List<SpacecraftsModel>> data) {
            if (data.hasError) {
              return const Center(
                child: Text("Something went wrong try check your internet"),
              );
            }

            if (data.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Center(
                        child: Text("Spacecrafts", textScaleFactor: 3)),
                    const SizedBox(height: 10),
                    Text(
                      "As of now their is ${data.data!.length} Spacecrafts made by ISRO. All spacecrafts name is given below:- ",
                      textScaleFactor: 1.6,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: data.data!.length,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              leading: Text("${index + 1}"),
                              title: Text(data.data![index].name),
                            );
                          }),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        // body: SingleChildScrollView(
        //   padding: const EdgeInsets.all(8),
        //   child: Column(
        //     children: const [
        //       Center(child: Text("Spacecrafts", textScaleFactor: 3)),
        //       SizedBox(height: 10),
        //       Text(
        //         "As of now their is 112 Spacecrafts made by ISRO. All spacecrafts name is given below:- ",
        //         textScaleFactor: 1.6,
        //         textAlign: TextAlign.justify,
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
