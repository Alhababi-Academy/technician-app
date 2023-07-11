import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class videoDetails extends StatefulWidget {
  const videoDetails({Key? key}) : super(key: key);

  @override
  State<videoDetails> createState() => _videoDetailsState();
}

class _videoDetailsState extends State<videoDetails> {
  final List<Map<String, String>> videoDetails = [
    {
      "title": "How to check Cars Tires",
      "link": "https://youtu.be/6PM3M6lWGHM",
    },
    {
      "title": "How to Change Cars Oil",
      "link": "https://youtu.be/O1hF25Cowv8",
    },
    {
      "title": "How to jumpstart your car",
      "link": "https://youtu.be/wwYrFzwylLo",
    },
    {
      "title": "How to Replace a Headlight",
      "link": "https://youtu.be/ax5qKLAHkyA",
    },
    {
      "title": "How to Change a Brake Pad",
      "link": "https://youtu.be/x2rTxWx-LfQ",
    },
  ];

  void _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri);
    } catch (e) {
      print("Error occurred while launching URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn How"),
        centerTitle: true,
      ),
      body: SafeArea(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title.toString()),
                          GestureDetector(
                            onTap: () {
                              _launchURL(link!);
                            },
                            child: Text(
                              link.toString(),
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                              ),
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
    );
  }
}
