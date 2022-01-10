import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isro_pedia/helper/api.dart';
import 'package:isro_pedia/models/centres_model.dart';
import 'package:http/http.dart' as http;

class CentresScreen extends StatelessWidget {
  const CentresScreen({Key? key}) : super(key: key);

  Future<List<CentresModel>> fetchData() async {
    List<CentresModel> data = [];
    await http.get(Uri.parse(centres)).then((value) {
      if (value.statusCode == 200) {
        List res = jsonDecode(value.body)["centres"];

        for (var element in res) {
          data.add(CentresModel(element["name"].toString(),
              element["Place"].toString(), element["State"].toString()));
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
          builder: (ctx, AsyncSnapshot<List<CentresModel>> data) {
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
                        child: Text("Centres", textScaleFactor: 3)),
                    const SizedBox(height: 10),
                    Text(
                      "As of now their is ${data.data!.length} Centres in India. All centres details are given below:- ",
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
                              subtitle: Text(data.data![index].place + "  (" + data.data![index].state + ")"),
                              isThreeLine: true,
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
      ),
    );
  }
}
