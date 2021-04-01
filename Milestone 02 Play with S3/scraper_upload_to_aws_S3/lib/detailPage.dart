import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
// import 'amplifyconfiguration.dart';

import 'Page.dart';

class ResultPages extends StatefulWidget {
///////////////////////

  ///////////////////////
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
  bool isAmplifyConfigured = false;
  String _uploadFileResult = '';
  String _getUrlResult = '';
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
          // Task2
          uploadToAWSS3();
        },
        tooltip: 'Upload to AWS S3 Bucket',
        label: Icon(Icons.cloud_upload, size: 30),
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

  Future<void> uploadToAWSS3() async {
    ////
    configureAmplify();
    ////
    try {
      print('In upload');
      // Uploading the file with options
      dynamic local = await FilePicker.platform.pickFiles(type: FileType.image);
      final key = new DateTime.now().toString();
      Map<String, String> metadata = <String, String>{};
      metadata['name'] = 'filename';
      metadata['desc'] = 'A test file';
      S3UploadFileOptions options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest, metadata: metadata);
      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key, local: local, options: options);
      setState(() {
        _uploadFileResult = result.key;
      });
    } catch (e) {
      print('UploadFile Err: ' + e.toString());
    }
  }

  ////////
  void configureAmplify() async {
    // First add plugins (Amplify native requirements)
    AmplifyStorageS3 storage = new AmplifyStorageS3();
    AmplifyAuthCognito auth = new AmplifyAuthCognito();
    Amplify.addPlugins([auth, storage]);

    try {
      // Configure
      // await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          'Amplify was already configured. Looks like app restarted on android.');
    }

    setState(() {
      isAmplifyConfigured = true;
    });
  }

  void upload() async {
    try {
      print('In upload');
      // Uploading the file with options
      dynamic local = await FilePicker.platform.pickFiles(type: FileType.image);
      final key = new DateTime.now().toString();
      Map<String, String> metadata = <String, String>{};
      metadata['name'] = 'Cat';
      metadata['desc'] = 'A Image file';
      S3UploadFileOptions options = S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest, metadata: metadata);
      UploadFileResult result = await Amplify.Storage.uploadFile(
          key: key, local: local, options: options);
      setState(() {
        _uploadFileResult = result.key;
      });
    } catch (e) {
      print('UploadFile Err: ' + e.toString());
    }
  }

  void getUrl() async {
    try {
      print('In getUrl');
      String key = _uploadFileResult;
      S3GetUrlOptions options = S3GetUrlOptions(
          accessLevel: StorageAccessLevel.guest, expires: 10000);
      GetUrlResult result =
          await Amplify.Storage.getUrl(key: key, options: options);

      setState(() {
        _getUrlResult = result.url;
      });
    } catch (e) {
      print('GetUrl Err: ' + e.toString());
    }
  }
}
