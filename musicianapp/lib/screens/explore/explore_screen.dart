import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicianapp/common/common_widgets.dart';
import 'package:musicianapp/models/explore_model.dart';
import 'package:musicianapp/screens/explore/profile_screen.dart';
import 'package:musicianapp/screens/account/setprofile_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

List<String> videoList=[];

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({ Key? key }) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    final PageController controller = PageController();
    bool showGuide = true;

    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          IconButton(onPressed: (){showFilterView();}, icon: const Icon(CupertinoIcons.bars),)
        ],
      ),*/
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Consumer<Explorer>(
                builder: (context, explorerModel, child) {
                  if(Explorer.initialized == true){
                    return PageView(
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      allowImplicitScrolling: true,
                      children: List<Widget>.generate(explorerModel.videoList.length, (int index) {
                        return VideoApp(explorerModel.videoList[index]);
                      },
                      ).toList(),
                    );
                  }else{
                    return Center(child: Text('Select Filter Settings to Explore Musicians'));
                  }
                },
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close_rounded,color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(12),
                          primary: Color(0xFF303952), // <-- Button color
                          onPrimary: Color(0xFF40407a), // <-- Splash color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showFilterView();
                        },
                        child: FaIcon(FontAwesomeIcons.slidersH,color: Colors.white,size: 20,),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(12),
                          primary: Color(0xFF303952), // <-- Button color
                          onPrimary: Color(0xFF40407a), // <-- Splash color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //if (showGuide) Center(child: Text('Select filter settings to start exploring'),) else Container(),
            ],
          ),
        ),
      ),
    );
  }
  void showFilterView(){
    showModalBottomSheet<dynamic>(
      //isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0),),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return FilterView();
      },
    );
  }

  void updateSearch(){
    setState((){});
  }
}

enum filterType {byDistance, byRole}

class FilterView extends StatefulWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {

  filterType _type = filterType.byRole;
  List roleList = ['Any Role','Composer','Instrumentalist','Vocalist', 'Producer'];
  List<String> genreList = ['Any Genre','Pop','Classical','Rock', 'Jazz'];
  List instrumentList = ['Any Instrument','Guitar','Piano','Drums', 'Violin','Harp','Cello','Trumpet','Viola','Bass Guitar','Percussion','Flute'];
  String roleChoice = 'Any Role';
  String genreChoice = 'Any Genre';
  String instrumentChoice = 'Any Instrument';
  double distance = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 12),
                child: const Text('Filter',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ),
              IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.close),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Radio<filterType>(
                    value: filterType.byRole,
                    groupValue: _type,
                    onChanged: (filterType? value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  Text('By Role'),
                ],
              ),
              Row(
                children: [
                  Radio<filterType>(
                    value: filterType.byDistance,
                    groupValue: _type,
                    onChanged: (filterType? value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  Text('By Distance'),
                ],
              ),
            ],
          ),
          Expanded(
            child: _type == filterType.byRole ? filterContentRole() : filterContentDistance(),
          ),

        ],
      ),
    );
  }
  Widget filterContentRole(){
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('ROLE'),
              Wrap(
                spacing: 4,
                children: List<Widget>.generate(roleList.length, (int index) {
                  return ChoiceChip(
                    label: Text(roleList[index]),
                    selected: roleChoice == roleList[index],
                    onSelected: (bool selected) {
                      setState(() {
                        roleChoice = selected ? roleList[index] : null;
                      });
                    },
                  );
                },
                ).toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GENRE'),
              Wrap(
                spacing: 4,
                children: List<Widget>.generate(genreList.length, (int index) {
                  return ChoiceChip(
                    label: Text(genreList[index]),
                    selected: genreChoice == genreList[index],
                    onSelected: (bool selected) {
                      setState(() {
                        genreChoice = (selected ? genreList[index] : null)!;
                      });
                    },
                  );
                },
                ).toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INSTRUMENT'),
              Container(
                child: roleChoice != 'Instrumentalist' ? Center(child: Text('Not Applicable'),) :
                Wrap(
                  spacing: 4,
                  children: List<Widget>.generate(instrumentList.length, (int index) {
                    return ChoiceChip(
                      label: Text(instrumentList[index]),
                      selected: instrumentChoice == instrumentList[index],
                      onSelected: (bool selected) {
                        setState(() {
                          instrumentChoice = selected ? instrumentList[index] : null;
                        });
                      },
                    );
                  },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Consumer<Explorer>(
            builder: (context, explorerModel, child) {
              return ElevatedButton(
                onPressed: (){
                  explorerModel.searchUsersByMusic(roleChoice,instrumentChoice,genreList);
                  Navigator.pop(context);
                  //videoList = explorerModel.videoList;
                },
                child: const Text('SEARCH'),
              );
            }
          ),
        ),

      ],
    );
  }

  Widget filterContentDistance(){
    return ListView(
      children: [
        SizedBox(height: 60,),
        Center(child: Text('${distance.round().toString()} km'),),
        Slider(
          value: distance,
          min: 1,
          max: 100,
          //divisions: 10,
          label: distance.round().toString(),
          onChanged: (double value) {
            setState(() {
              distance = value;
            });
          },
        ),
        SizedBox(height: 20,),
        Center(
          child: Consumer<Explorer>(
              builder: (context, explorerModel, child) {
                return ElevatedButton(
                  onPressed: (){
                    explorerModel.searchUsersByDistance(distance.roundToDouble());
                    Navigator.pop(context);
                    //videoList = explorerModel.videoList;
                  },
                  child: const Text('SEARCH'),
                );
              }
          ),
        ),
      ],
    );
  }
}



class VideoApp extends StatefulWidget {
  String link;
  VideoApp(this.link, {Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.link)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    //_controller.play();
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: _controller.value.isInitialized ?
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(
              _controller,
            ),
          ) :
          const Center(child: spinkit),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _controller.value.isPlaying ? (){
                      setState(() {
                        _controller.pause();
                      });
                    } : (){
                      setState(() {
                        _controller.play();
                      });
                    },
                    child: _controller.value.isPlaying ? Icon(Icons.pause,color: Colors.white,) : Icon(Icons.play_arrow,color: Colors.white,),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12),
                      primary: Color(0xFF303952), // <-- Button color
                      onPrimary: Color(0xFF40407a), // <-- Splash color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showProfileView();
                    },
                    child: Icon(Icons.person,color: Colors.white,),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12),
                      primary: Color(0xFF303952), // <-- Button color
                      onPrimary: Color(0xFF40407a), // <-- Splash color
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void play(){

  }

  void showProfileView(){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


}

class CircleButton extends StatelessWidget {

  Function function;
  Icon icon;

  CircleButton({
    required this.function,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        function;
      },
      child: icon,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
        primary: Colors.blue, // <-- Button color
        onPrimary: Colors.red, // <-- Splash color
      ),
    );
  }
}
