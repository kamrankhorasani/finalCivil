import 'package:civil_project/models/fileModel.dart';
import 'package:civil_project/models/imageView.dart';
import 'package:civil_project/models/pdfView.dart';
import 'package:flutter/material.dart';
import 'package:civil_project/constants/constantdecorations.dart';

class ItemDetails extends StatefulWidget {
  final String title;
  final String name;
  final String date;
  final Icon logo;
  final List files;

  ItemDetails(
      {Key key, this.title, this.name, this.date, this.logo, this.files})
      : super(key: key);
  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

//enum Acceptance { accept, refuse }

class _ItemDetailsState extends State<ItemDetails> {
  List<FileModel> _pickedFiles = [];
  @override
  void initState() {
    super.initState();
    widget.files.forEach((element) {
      _pickedFiles.add(FileModel(
        title: element['title'],
        address: element["file"],
        image: element['file'].toString().contains("pdf")
            ? Image.asset("assets/images/pdf.png", height: 90)
            : Image.asset("assets/images/imagelogo.png", height: 90),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.1),
            child: Container(
              height: height * 0.5,
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.01, vertical: height * 0.01),
              decoration: containerShadow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: height * 0.2,
                        width: width * 0.25,
                        child: Image.asset("assets/images/noimage.png",
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(widget.title),
                          SizedBox(height: height * 0.04),
                          Text(widget.name),
                          SizedBox(height: height * 0.04),
                          Text(widget.date.substring(0, 9)),
                        ],
                      ),
                      SizedBox(
                        width: width * 0.30,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.25,
                    width: double.maxFinite,
                    child: ListView.separated(
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Stack(children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_pickedFiles[index].format == 'pdf') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PDFView(
                                                  address: _pickedFiles[index]
                                                      .address)));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ImageView(
                                                  address: _pickedFiles[index]
                                                      .address)));
                                    }
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: _pickedFiles[index].image),
                                ),
                                Text(_pickedFiles[index].title)
                              ],
                            ),
                            Positioned(
                              height: 56,
                              width: 25,
                              top: -1,
                              right: -10,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    size: 30,
                                    color: Colors.pinkAccent[400],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _pickedFiles.removeAt(index);
                                    });
                                  }),
                            )
                          ]);
                        },
                        separatorBuilder: (context, index) => VerticalDivider(),
                        itemCount: _pickedFiles.length),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              child: Padding(
            padding: EdgeInsets.all(15.0),
            child: IconButton(
                iconSize: 30,
                icon: Icon(Icons.cancel, color: Colors.red),
                onPressed: () => Navigator.pop(context)),
          ))
        ],
      ),
    );
  }
}
