import 'package:flutter/material.dart';
import 'package:technicianApp/userHomePages/videoMoreDetials.dart';

String linkFin = "6PM3M6lWGHM";

class videoDetails extends StatefulWidget {
  const videoDetails({Key? key}) : super(key: key);

  @override
  State<videoDetails> createState() => _videoDetailsState();
}

class _videoDetailsState extends State<videoDetails> {
  final List<Map<String, String>> videoDetails = [
    {"title": "How to check Cars Tires", "link": "6PM3M6lWGHM"},
    {"title": "How to Change Cars Oil", "link": "O1hF25Cowv8"},
    {"title": "How to jumpstart your car", "link": "wwYrFzwylLo"},
    {"title": "How to Replace a Headlight", "link": "ax5qKLAHkyA"},
    {"title": "How to Change a Brake Pad", "link": "x2rTxWx-LfQ"},
    {"title": "How to Replace a Car Battery", "link": "kKxbyMApkj0"},
    {"title": "How to Replace Spark Plugs", "link": "m_ZsWQ_WXNo"},
    {"title": "How to Change a Car's Air Filter", "link": "RdXVxbd59es"},
    {
      "title": "How to Flush and Fill Coolant/Antifreeze",
      "link": "g8YZF5cW7-A"
    },
    {"title": "How to Replace a Car's Serpentine Belt", "link": "riWXM5QdfFk"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn How"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: videoDetails.length,
                    itemBuilder: (BuildContext context, int index) {
                      final title = videoDetails[index]['title'];
                      final link = videoDetails[index]['link'];
                      return Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        link.toString(),
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Route route = MaterialPageRoute(
                                          builder: (_) => showingVideo(
                                                videoTitle: title!,
                                                videoLink: link!,
                                              ));
                                      Navigator.push(context, route);
                                      print(title.toString());
                                      print(link.toString());
                                    },
                                    icon: const Icon(
                                      Icons.pause_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
