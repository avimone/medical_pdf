import 'package:flutter/material.dart';
import 'package:medical_pdf/Screens/home_screen.dart';
import 'package:medical_pdf/model/analytics.dart';
import 'package:medical_pdf/model/subjects.dart';
import 'package:medical_pdf/widgets/new_item.dart';
import 'package:medical_pdf/widgets/new_subject.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class SubjectScreen extends StatefulWidget {
  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  var _isInit = true;
  var _isLoading = false;
  TextEditingController _searchController = TextEditingController();
  FocusNode _search = FocusNode();
  var valueSearch;
  List<String> backupList = [];
  List<String> filteredList = [
    /*   'Anatomy',
    "Pathophysiology",
    'Pathology',
    'Surgery',
    'Pharmacology',
    'Orthopaedics',
    'Other' */
  ];
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Subjects>(context).fetchAndSetSubjects().then((_) {
        var subjects = Provider.of<Subjects>(context, listen: false);

        setState(() {
          var subjectList = subjects.items;
          filteredList = subjectList;
          backupList = subjectList;

          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void _addNewTransaction(String name) {
    setState(() {
      final data = Provider.of<Subjects>(context, listen: false);
      data.addSubject(name);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewSubject(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Subjects>(context, listen: false)
        .fetchAndSetSubjects()
        .then((_) {
      var subjects = Provider.of<Subjects>(context, listen: false);

      var subjectList = subjects.items;
      filteredList = subjectList;
      backupList = subjectList;
      setState(() {});
    });
  }

  void _submitData(String val) {
    final enteredVal = _searchController.text;
    valueSearch = _searchController.text;
    analytics.logEvent(name: "search", parameters: {"search": val});
    mixpanel.track('search', properties: {"search": val});
    setState(() {
      filteredList = backupList
          .where(
              (element) => (element.toLowerCase().contains(val.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subjects"),
        backgroundColor: Color(0xFF9D1B6F),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: _isLoading
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
                      onChanged: (val) => _submitData(val),
                      onSubmitted: (val) => _submitData(val),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      color: Color(0xFFEEF5DB),
                      child: ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, i) {
                            //   print(books[i].name);
                            return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xFF45CDE1),
                                ),
                                margin:
                                    EdgeInsets.only(top: 3, left: 5, right: 5),
                                child: ListTile(
                                  title: Text(filteredList[i]),
                                  hoverColor: Color(0xFF7A9E9F),
                                  focusColor: Color(0xFF7A9E9F),
                                  selectedTileColor: Color(0xFF7A9E9F),
                                  onTap: () {
                                    analytics.logEvent(
                                        name: "subject_name",
                                        parameters: {"name": filteredList[i]});
                                    mixpanel.track('subject_name',
                                        properties: {"name": filteredList[i]});

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen(filteredList[i])));
                                  },
                                ));
                          }),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
