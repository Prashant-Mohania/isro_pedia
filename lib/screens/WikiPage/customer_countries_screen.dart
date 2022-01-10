import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isro_pedia/helper/api.dart';
import 'dart:convert';

import 'package:isro_pedia/models/customer_countries_model.dart';

class CustomerCounteriesScreen extends StatelessWidget {
  const CustomerCounteriesScreen({Key? key}) : super(key: key);

  Future<List<CustomerCountriesModel>> fetchData() async {
    List<CustomerCountriesModel> data = [];
    await http.get(Uri.parse(customerSatellites)).then((value) {
      if (value.statusCode == 200) {
        List res = jsonDecode(value.body)["customer_satellites"];

        for (var element in res) {
          data.add(CustomerCountriesModel(
              element["country"].toString(),
              element["launch_date"].toString(),
              element["launcher"].toString()));
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
            builder: (ctx, AsyncSnapshot<List<CustomerCountriesModel>> data) {
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
                          child: Text("Launchers", textScaleFactor: 3)),
                      const SizedBox(height: 10),
                      Text(
                        "As of now their is ${data.data!.length} countries satellites are launched by ISRO. All countries satellite details are given below:- ",
                        textScaleFactor: 1.6,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: data.data!.length,
                            itemBuilder: (ctx, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Name",
                                          textScaleFactor: 1.2,
                                        ),
                                        Text(
                                          data.data![index].country,
                                          textScaleFactor: 1.2,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Launch Date",
                                          textScaleFactor: 1.2,
                                        ),
                                        Text(
                                          data.data![index].launchDate,
                                          textScaleFactor: 1.2,
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Launcher",
                                          textScaleFactor: 1.2,
                                        ),
                                        Text(
                                          data.data![index].launcher,
                                          textScaleFactor: 1.2,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
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
            }),
      ),
    );
  }
}
