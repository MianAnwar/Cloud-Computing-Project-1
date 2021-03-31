import 'package:flutter/material.dart';

import 'Page.dart';

class ResultPages extends StatefulWidget {
  final List<String> cats;
  final List<String> dogs;
  final List<String> cars;
  final List<String> bikes;
  final List<String> cycles;

  ResultPages({this.cats, this.dogs, this.bikes, this.cycles, this.cars});

  @override
  _ResultPagesState createState() => _ResultPagesState();
}

class _ResultPagesState extends State<ResultPages>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  //

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////////////////////////
    List<Widget> tabs = List<Widget>();
    List<Widget> pages = List<Widget>();
    setState(
      () {
        tabs.add(
          Tab(
            child: Text('Cats',
                style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 21.0,
                )),
          ),
        );
        tabs.add(
          Tab(
            child: Text('Dogs',
                style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 21.0,
                )),
          ),
        );
        tabs.add(
          Tab(
            child: Text('Cars',
                style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 21.0,
                )),
          ),
        );
        tabs.add(
          Tab(
            child: Text('Bikes',
                style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 21.0,
                )),
          ),
        );
        tabs.add(
          Tab(
            child: Text('Cycles',
                style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 21.0,
                )),
          ),
        );

        pages.add(CPage(widget.cats));
        pages.add(CPage(widget.dogs));
        pages.add(CPage(widget.cars));
        pages.add(CPage(widget.bikes));
        pages.add(CPage(widget.cycles));
      },
    );

    return Scaffold(
///////////////////////////////////////////////////////////////////
      appBar: buildAppBar(),
///////////////////////////////////////////////////////////////////
      body: ListView(
        children: <Widget>[
          SizedBox(height: 15.0),
          //TAB BAR are showing with this
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Colors.blue,
              isScrollable: true,
              labelPadding: EdgeInsets.only(right: 45.0),
              unselectedLabelColor: Color(0xFFCDCDCD),
              tabs: tabs,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 50.0,
            width: double.infinity,
            child: TabBarView(
              controller: _tabController,
              children: pages,
            ),
          ),
        ],
      ),
///////////////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // upload to AWS S3 Bucket
        },
        tooltip: 'Upload to AWS S3 Bucket',
        label: Icon(
          Icons.cloud_upload,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: BottomBar(i: 1),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      title: Text('Categories',
          style: TextStyle(
              fontFamily: 'Varela', fontSize: 22.0, color: Color(0xFF545D68))),
    );
  }
}
