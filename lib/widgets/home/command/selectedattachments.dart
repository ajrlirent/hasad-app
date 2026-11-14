import 'package:hasad/data/models/attachmentmodel.dart';
import 'package:flutter/material.dart';

class SelectedAttachemtns extends StatelessWidget {
  final List<AttachmentModel> data;
  const SelectedAttachemtns({
    super.key, required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.isEmpty ? 1 : data.length,
          itemBuilder: (context, index) => Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                child: data.isEmpty
                    ? const Center(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 80),
                          child: Text(
                            "No data",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 80),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                data[index].attachmentimage!,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                data[index].attachmentname!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 13),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
              )),
    );
  }
}
