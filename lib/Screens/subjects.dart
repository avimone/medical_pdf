import 'package:flutter/material.dart';
import 'package:medical_pdf/Screens/home_screen.dart';
import 'package:medical_pdf/model/subjects.dart';
import 'package:medical_pdf/widgets/new_item.dart';
import 'package:medical_pdf/widgets/new_subject.dart';
import 'package:provider/provider.dart';

class SubjectScreen extends StatefulWidget {
  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  var _isInit = true;
  var _isLoading = false;
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subjects"),
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
            : Container(
                height: double.infinity,
                padding: EdgeInsets.only(top: 5),
                color: Color(0xFFEEF5DB),
                child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, i) {
                      //   print(books[i].name);
                      return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFB8D8D8),
                          ),
                          margin: EdgeInsets.only(top: 3, left: 5, right: 5),
                          child: ListTile(
                            title: Text(filteredList[i]),
                            hoverColor: Color(0xFF7A9E9F),
                            focusColor: Color(0xFF7A9E9F),
                            selectedTileColor: Color(0xFF7A9E9F),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(filteredList[i])));
                            },
                          ));
                    }),
              ),
      ),
    );
  }
}
