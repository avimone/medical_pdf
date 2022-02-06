import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:medical_pdf/widgets/new_item.dart';
import 'package:medical_pdf/widgets/pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medical_pdf/model/books.dart';
import 'package:medical_pdf/model/book.dart';

import 'package:dio/dio.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;
const String testDevice = '98E429C622AAB67C2E6328A3D812DE27';

class HomeScreen extends StatefulWidget {
  String type;
  HomeScreen(this.type);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;
  TextEditingController _searchController = TextEditingController();
  FocusNode _search = FocusNode();
  List<String> listOfBooks = [
    "Current Diagnosis _ Treatment Obstetrics _ Gynecology (2012, McGraw-Hill Medical)",
    "Current Medical Diagnosis and Treatment Flashcards (2013, McGraw-Hill)",
    "Current Medical Diagnosis and Treatment Study Guide (2015, McGraw-Hill)",
    "Current-Diagnosis-and-Treatment-Surgery",
    "Davidson_s Essentials of Medicine, 2e (2015, Churchill Livingstone)",
    "Davidson's Principles and practice of medicine (2018, Elsevier)",
    "Davidson's Self-assessment in Medicine (2018, Elsevier)",
    "DIAGNOSTIC ULTRASOUND",
    "Essentials-of-Kumar-Clark-s-Clinical-Medicine",
    "Ghai Essential Pediatrics, 9e (2018, CBS Publishers _ Distributors_)",
    "Ghai Essential Pediatrics",
    "Goldman-Cecil-Medicine",
    "Gynaecological Instruments",
    "Hamilton-Bailey-s-Physical-Signs-Demonstrations-of-Physical-Signs-in-Clinical-Surgery",
    "Harrison_s Manual of Medicine-McGraw-Hill (2016)",
    "Harrison_s Principles of Internal Medicine (19th Edition)",
    "HARRISON'S INFECTIOUS DISEASES 3rd Edition",
    "Hiralal Konar-DC Dutta_s Textbook of Gynecology-Jaypee Brothers (2014)",
    "Hiralal Konar-DC Dutta_s Textbook of Obstetrics_ Including Perinatology and Contraception-JP Medical Pub",
    "Hutchison's Clinical Methods_ An Integrated Approach to Clinical Practice (2017, Elsevier)",
    "J. Maheshwari, Vikram A. Mhaskar - Essential Orthopaedics (2015, Jaypee Brothers Medical Pub)",
    "Jorge Muniz - Medcomic The Most Entertaining Way to Study Medicine (2018, Jorge Muniz)",
    "K. George Mathew, Praveen Aggarwal - Medicine_ Prep Manual for Undergraduates (2015, Elsevier India)",
    "Kumar _ Clark's Tien - Kumar _ Clark's Clinical Medicine 9e (2016)",
    "Lorraine M Sdrales, Ronald D. Miller - Miller's Anesthesia Review (2012, Saunders)",
    "Macleod_s Clinical Examination 14th Edition",
    "Macleod's Clinical Examination-Churchill Livingstone",
    "Manuel Pardo, Ronald D. Miller - Basics of Anesthesia (2017, Elsevier)",
    "Maxine A. Papadakis, Stephen J. McPhee, Michael W. Rabow - Current Medical Diagnosis _ Treatment",
    "Mayo Clinic Scientific Press Lyell Jones, Kelly Flemming - Mayo Clinic Neurology Board Review_ Basic Sciences and Psychiatry for Initial Certification",
    "Medcomic-The-Most-Entertaining-Way-to-Study-Medicine",
    "Medical Specialty Board Review Rajesh Tampi, Kristina Zdanys, Mark Oldham - Psychiatry _ a comprehensive board review",
    "Michael South, Maxwell J. Robinson, David Isaacs MB BChir MD MRCP FRACP, Don M. Roberton-Practical Paediatrics, 5th Edition ",
    "Neena Khanna - Illustrated Synopsis Of Dermatology and Sexually Transmitted Diseases",
    "Nelson-essentials-of-pediatrics",
    "Nelson-Textbook-of-Pediatrics-2-Volume-Set-20e",
    "Niraj Ahuja - A Short Textbook of Psychiatry_ 20th Year Edition",
    "Operative Techniques In SURGERY",
    "Oxford Handbook of Clinical Diagnosis",
    "Oxford Handbook of Clinical Examination and Practical Skills",
    "Oxford Handbook of Clinical Medicine",
    "Oxford Handbook of Clinical Specialities",
    "Oxford Handbook of Clinical Surgery",
    "Oxford Handbook of emergency medicine",
    "Oxford Handbook of Obstetrics and Gynaecology",
    "Oxford medical handbooks Robert C Tasker_ Robert J McClure_ Carlo L Acerini - Oxford handbook of paediatrics",
    "Oxorn Foote Human Labor and Birth",
    "P. J. Mehta - Practical Medicine",
    "Paediatrics -O.P. Ghai",
    "Parveen Kumar, Michael L Clark - Kumar and Clark_s Clinical Medicine",
    "Paula Derr, Jon Tardiff, Mike McEvoy - Emergency  _  Critical Care Pocket Guide, ACLS version",
    "Perspectives-on-Practice",
    "Pocket-Medicine-The-Massachusetts-General-Hospital-Handbook-of-Internal-Medicine",
    "practical-aspects-of-pediatrics-5th-edition",
    "Rajat Jain - Review of Radiology (2016, Jaypee Brothers Medical Publishers)",
    "Review - Harrison's principles of internal medicine, self-assessment and board review",
    "S.DAS CLINICAL SURGERY",
    "Sabiston-Textbook-of-Surgery-Missing-Pages-ONLY",
    "Sabiston-Textbook-of-Surgery-The-Biological-Basis-of-Modern-Surgical-Practice",
    "Schwartz_s Principles of Surgery",
    "Shaw's  Textbook of Gynaecology",
    "SRB Manual of Surgery 5th Edition",
    "Systolic murmur",
    "The Handbook of Fracture",
    "Tintinalli's Emergency Medicine Manual-McGraw-Hill",
    "Tom Lissauer_ Graham Clayden-Illustrated Textbook of Paediatrics _ With STUDENT CONSULT Online Access-Elsevier Health Sciences UK, Mosby",
    "Williams Obstetrics 24th Ed",
  ];
  String assetPDFPath = "";
  List<String> urlPDFPath = [];
  var _isInit = true;
  String pdfpath = "";
//  bool downloading = false;
  var progressString = "";
  var progressInt;
  var ongoingDownload = false;
  var downloadstate = false;
  var valueSearch;
  Book ongoinDown;
//  var downloaded = false;
  var _isLoading = false;
  final InterstitialAd myInterstitial = InterstitialAd(
    adUnitId:Platform.isIOS ? 'ca-app-pub-4408166895540676/8550898152': 'ca-app-pub-4408166895540676/8752103666',
    request: AdRequest(),
    listener: AdListener(),
  );

  String host = "https://www.gadgetspidy.com/medical/";

  @override
  void initState() {
    super.initState();
    /*  RequestConfiguration.Builder()
        .setTestDeviceIds(Arrays.asList("98E429C622AAB67C2E6328A3D812DE27")); */
    myInterstitial.load();

    /*  getFileFromAsset("assets/mypdf.pdf").then((f) {
      setState(() {
        assetPDFPath = f.path;
        print(assetPDFPath);
      });
    });
 */
    //  Provider.of<Books>(context).fetchAndSetBooks();
  }

  final AdListener listener = AdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();

      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) {
      ad.dispose();
      print('Ad closed.');
    },
    // Called when an ad is in the process of leaving the application.
    onApplicationExit: (Ad ad) => print('Left application.'),
  );
  List<Book> filteredList = [];

  void _submitData(List<Book> products, String val) {
    final enteredVal = _searchController.text;
    valueSearch = _searchController.text;
    setState(() {
      filteredList = products
          .where((element) =>
              (element.name.toLowerCase().contains(val.toLowerCase())))
          .toList();
    });
  }

  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdf.pdf");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }

  Future<File> getFileFromUrl(String url) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  void _addNewTransaction(String txname, int id, String imageUrl, String link) {
    final newTx = Book(
      name: txname,
      id: id.toString(),
      link: link,
      imageUrl: imageUrl,
    );
    // imageUrl: 'https://gadgetspidy.com/pik/Asset.png');
    //   print(id);
    setState(() {
      final productsData = Provider.of<Books>(context, listen: false);
      productsData.addBook(newTx.id, newTx.name, newTx.link, newTx.imageUrl);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewItem(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (ongoingDownload) {
      deleteFile(ongoinDown);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Books>(context).fetchAndSetBooks().then((_) {
        var books = Provider.of<Books>(context, listen: false);
        var bookList = books.items;

        setState(() {
          var showBook = bookList
              .where((element) =>
                  element.id.toLowerCase().contains(widget.type.toLowerCase()))
              .toList();
          print(bookList);
          print(showBook);
          filteredList = showBook;
          confirmDownload();
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _showMyDialog(Book books) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!!! Your pdf will open shortly'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Your PDF is ready",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
                Text(
                  'This will be depend on your internet connection',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> downloadFile(Book book, String todo) async {
    Dio dio = Dio();

    try {
      var filename = book.name;
      Directory dir = Platform.isIOS ?  await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();
      var pathName = dir.path ;
      if (await File("${pathName}/$filename.pdf").exists()) {
        setState(() {
          book.downloaded = true;
        });
        return;
      }
      print(pathName);
      await dio.download(book.link, "${pathName}/$filename.pdf",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        book.downloading = true;
        ongoingDownload = true;
        ongoinDown = book;
        setState(() {
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          progressInt = int.parse(((rec / total) * 100).toStringAsFixed(0));
          prefs.setInt("progress", progressInt).then((bool success) {
            return progressInt;
          });
          prefs.setString("file", filename).then((bool success) {
            return filename;
          });
          book.pdfpath = "${pathName}/$filename.pdf";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      book.downloading = false;
      book.downloaded = true;
      progressString = "Completed";
      ongoingDownload = false;
    });
    print("completed");
  }

  Future<void> checkFile(Book book) async {
    try {
      var filename = book.name;
      Directory dir = Platform.isIOS ?  await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();
      if (await File("${dir.path}/$filename.pdf").exists()) {
        setState(() {
          book.downloaded = true;
          book.pdfpath = "${dir.path}/$filename.pdf";
        });
        return;
      }
      print(dir.path);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteFile(Book book) async {
    try {
      var filename = book.name;
      Directory dir = Platform.isIOS ?  await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();
      if (await File("${dir.path}/$filename.pdf").exists()) {
        File("${dir.path}/$filename.pdf").delete();

        return;
      }
      print(dir.path);
    } catch (e) {
      print(e);
    }
  }

  Future<void> confirmDownload() async {
    prefs = await _prefs;
    final int progress = (prefs.getInt('progress'));
    final String progressItem = (prefs.getString('file'));
    print(progress);
    print(progressItem);
    if (progress > 0 && progress != 100) {
      Directory dir = Platform.isIOS ?  await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();

      if (await File("${dir.path}/$progressItem.pdf").exists()) {
        File("${dir.path}/$progressItem.pdf").delete();

        return;
      }
    }
  }

/* Future<File> createFile() async {
    try {
      /// setting filename 
      final filename = widget.docPath;

      /// getting application doc directory's path in dir variable
      String dir = (await getApplicationDocumentsDirectory()).path;

      /// if `filename` File exists in local system then return that file.
      /// This is the fastest among all.
      if (await File('$dir/$filename').exists()) return File('$dir/$filename');

      ///if file not present in local system then fetch it from server

      String url = widget.documentUrl;

      /// requesting http to get url
      var request = await HttpClient().getUrl(Uri.parse(url));

      /// closing request and getting response
      var response = await request.close();

      /// getting response data in bytes
      var bytes = await consolidateHttpClientResponseBytes(response);

      /// generating a local system file with name as 'filename' and path as '$dir/$filename'
      File file = new File('$dir/$filename');

      /// writing bytes data of response in the file.
      await file.writeAsBytes(bytes);

      /// returning file.
      return file;
    }

    /// on catching Exception return null
    catch (err) {
      errorMessage = "Error";
      print(errorMessage);
      print(err);
      return null;
    }
  } */
  @override
  Widget build(BuildContext context) {
    var booksData = Provider.of<Books>(context, listen: false);
    List<Book> books = booksData.items;

    return Scaffold(
      backgroundColor: Color(0xff3c4043),
      appBar: AppBar(
        title: Text("Books"),
        backgroundColor: Color(0xFF9D1B6F),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                //    _startAddNewTransaction(context);

                /*    final productsData = Provider.of<Books>(context, listen: false);
                for (var i in listOfBooks) {
                  productsData.addBook(
                      "All",
                      i,
                      "https://gadgetspidy.com/medical/",
                      "https://gadgetspidy.com/petroleum_images/No_Image_Available.png");
                } */
              }),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  color: Color(0xffdadce0),
                  child: TextField(
                    focusNode: _search,
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: InkWell(
                        child: Icon(Icons.close),
                        onTap: () {
                          _search.unfocus();
                        },
                      ),
                      labelText: 'Search',
                      hintText: 'Type Book name',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (val) => _submitData(books, val),
                    onSubmitted: (val) => _submitData(books, val),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, i) {
                        //   print(books[i].name);

                        print(filteredList[i].name +
                            filteredList[i].downloading.toString());
                        if (filteredList[i].isStart) {
                          filteredList[i].isStart = false;
                          checkFile(filteredList[i]);
                        }
                        return InkWell(
                            child: Card(
                              color: filteredList[i].downloading
                                  ? Color(0xff08f26e)
                                  : Color(0xffdadce0),
                              margin: EdgeInsets.only(
                                  top: 35, left: 30, right: 30, bottom: 15),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                width: 250,
                                height: 430,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 60,
                                      child: Text(
                                        filteredList[i].name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Averta-☞',
                                          color: Color(0xff80868b),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    /*   Text(books[i].id,
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontFamily: 'Averta-☞',
                                    color: Color(0xff679f3d),
                                  )), */
                                    const SizedBox(height: 1),
                                    filteredList[i]
                                            .imageUrl
                                            .contains("gadgetspidy")
                                        ? Image.network(
                                            filteredList[i].imageUrl,
                                            width: 400,
                                            height: 250,
                                          )
                                        : Image.asset(
                                            filteredList[i].imageUrl,
                                            width: 400,
                                            height: 250,
                                          ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                            icon: filteredList[i].downloaded
                                                ? Icon(
                                                    Icons.check,
                                                    color: Color(0xff006a4e),
                                                  )
                                                : filteredList[i].downloading
                                                    ? /* FocusedMenuHolder(
                                                  menuBoxDecoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(5))),
                                                  openWithTap: true,
                                                  menuItemExtent: 40,
                                                  menuWidth: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  onPressed: () {},
                                                  menuItems: <FocusedMenuItem>[
                                                    FocusedMenuItem(
                                                        backgroundColor:
                                                            const Color(0xff679f3d),
                                                        title: downloadstate == true
                                                            ? Text(" Pause",
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      'Averta-☞',
                                                                  color: Colors.white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight.w400,
                                                                  fontStyle: FontStyle
                                                                      .normal,
                                                                ))
                                                            : Text("Resume",
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      'Averta-☞',
                                                                  color: Colors.white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight.w400,
                                                                  fontStyle: FontStyle
                                                                      .normal,
                                                                )),
                                                        onPressed: () {}),
                                                    FocusedMenuItem(
                                                        backgroundColor:
                                                            const Color(0xff679f3d),
                                                        title: Text("Cancel Download",
                                                            style: TextStyle(
                                                              fontFamily: 'Averta-☞',
                                                              color: Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              fontStyle:
                                                                  FontStyle.normal,
                                                            )),
                                                        onPressed: () {
                                                          deleteFile(books[i]);
                                                        }),
                                                  ], */
                                                    // child:
                                                    Container(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 5,
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  Colors.white),
                                                          backgroundColor:
                                                              const Color(
                                                                  0xff679f3d),
                                                          value:
                                                              progressInt / 100,
                                                        ),
                                                        //  ),
                                                      )
                                                    : Icon(
                                                        Icons.download_rounded,
                                                        color:
                                                            Color(0xff006a4e)),
                                            onPressed: () {
                                              if (ongoingDownload == false) {
                                                downloadFile(filteredList[i],
                                                    'download');
                                                if (myInterstitial.isLoaded() !=
                                                    null) {
                                                  myInterstitial.show();
                                                } else {
                                                  myInterstitial.load();
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Another Download is in Progress")));
                                              }
                                            }),
                                        Text(
                                          filteredList[i].downloading
                                              ? "Downloading ${progressString}"
                                              : filteredList[i].downloaded
                                                  ? "Downloaded"
                                                  : "download",
                                          style: TextStyle(
                                              color: Color(0xff006a4e)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              /* if (urlPDFPath != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PdfViewPage(
                                        path: urlPDFPath[i],
                                        name: books[i].name,
                                        link: books[i].link,
                                      )));
                        } */

                              if (filteredList[i].pdfpath != null) {
                                if (ongoingDownload == false) {
                                  myInterstitial.show();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewPDF(
                                              pathPDF: filteredList[i].pdfpath,
                                            )),
                                    //  ModalRoute.withName('/'),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Download is in progress")));
                                }
                              } else {
                                setState(() {
                                  filteredList[i].downloaded = false;
                                  deleteFile(filteredList[i]);
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Please Download the PDF first  /  Downloaded PDF currpted please download again'),
                                    action: SnackBarAction(
                                      label: 'Download',
                                      textColor: Colors.white,
                                      onPressed: () {
                                        downloadFile(
                                            filteredList[i], 'download');
                                        // Some code to undo the change.
                                        //  Navigator.of(context).pop();
                                      },
                                    ),
                                  );

                                  // Find the ScaffoldMessenger in the widget tree
                                  // and use it to show a SnackBar.
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                              }
                            });
                      }),
                ),
              ],
            ),
    );
  }
}
