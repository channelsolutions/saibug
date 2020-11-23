import 'package:flutter/material.dart';
import 'package:gplayer/gplayer.dart';
import 'package:wakelock/wakelock.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title = 'sai TV'}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  TargetPlatform _platform = TargetPlatform.android;
  bool _isKeptOn = false;
  double _brightness = 1.0;
  static const String beeUri =
      'http://shinestream.in:1935/ssaitv/saitv/playlist.m3u8';
  //static bool showBackButton;
  GPlayer player = new GPlayer(uri: beeUri);

  void initState() {
    Wakelock.enable();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    this.video_initialize();
  }

  void video_initialize() {
    player = GPlayer(uri: beeUri)
      ..init()
      ..addListener((_) {
        //update control button out of player
        setState(() {});
      })
      ..start()
      ..lazyLoadProgress = 0
      ..isLive = true
      ..aspectRatio = 16.0 / 9.0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        player?.dispose();
        this.video_initialize();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        player?.mediaController?.control('exitFullScreen');
        player?.dispose();
        break;
      case AppLifecycleState.detached:
        player?.dispose();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    player?.dispose(); //2.release player
    super.dispose();
  }

  Widget _buildVideo() {
    return player.display;
  }

  Widget _buildFullScreenButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.white)),
      color: Colors.white,
      textColor: Colors.pinkAccent,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
        player?.mediaController?.control('toggleFullScreen');
      },
      child: Text('Fullscreen'),
    );
  }

  Widget _buldImage() {
    return Center(
      child: Image.asset(
        'assets/images/splash.png',
        width: 200,
      ),
    );
  }

  Widget _buildCopyRights() {
    return Text(
      'Designed @dnd communication',
      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
    );
  }

  Color gradientStart = Color(0xff0E3265); //Change start gradient color here
  Color gradientEnd = Color(0xff9FA2C2); //Change end gradient color here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: const FractionalOffset(0.5, 0.0),
              end: const FractionalOffset(0.0, 0.5),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 240.0,
            decoration: new BoxDecoration(
              color: Colors.black,
            ),
            child: Center(child: _buildVideo()),
          ),
          Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: const FractionalOffset(0.5, 0.0),
                end: const FractionalOffset(0.0, 0.5),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Center(
              child: _buildFullScreenButton(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: const FractionalOffset(0.5, 0.0),
                end: const FractionalOffset(0.0, 0.5),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                      child: _buldImage(),
                    ),
                    Container(
                        child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          // Your body widgets here
                          Expanded(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: _buildCopyRights() // Your footer widget
                                ),
                          ),
                        ],
                      ),
                    )),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
