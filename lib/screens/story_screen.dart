import 'package:flutter/material.dart';
import 'package:story/models/user.dart';
import 'package:story/models/story.dart';
import 'package:video_player/video_player.dart';
import 'home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final String userName;
  final String picture;
  StoryScreen(
      {required this.stories, required this.userName, required this.picture});

  @override
  StoryScreenState createState() => StoryScreenState();
}

class StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  int _currentIndex = 0;
  AnimationController? _animationController;
  bool _isMuted = false;
  VideoPlayerController? _videoPlayerController;
  bool isVideoInitialised = false;


  void initialiseVideoController() {
    StoryModel? video =
        widget.stories.firstWhere((story) => story.media_type == 'video');


      Uri videoUrl = Uri.parse(video.media_url);

      _videoPlayerController = VideoPlayerController.networkUrl(videoUrl)
        ..initialize().then((_) {
            setState(() {
              isVideoInitialised = true;
              _videoPlayerController!.play();
              _videoPlayerController!.setVolume(100);
            });
        });

  }

  void _toggleMute() {
    setState(() {
      if (_isMuted) {
        _videoPlayerController!.setVolume(100);
      } else {
        _videoPlayerController!.setVolume(0.0);
      }
      _isMuted = !_isMuted;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _pageController = PageController();
    initialiseVideoController();

    final StoryModel firststory = widget.stories.first;
    loadStory(story: firststory, animatPage: false);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController!.stop();
        _animationController!.reset();
        setState(() {
          if (_currentIndex + 1 < widget.stories.length) {
            _currentIndex += 1;
            loadStory(story: widget.stories[_currentIndex]);
          } else {
            //out of boundary
            _currentIndex = 0;
            loadStory(story: widget.stories[_currentIndex]);
          }
        });
      }
    });
  }

  @override
  void dispose() {
      _videoPlayerController!.dispose();

    _pageController!.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StoryModel currentStory = widget.stories[_currentIndex];
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        child: Scaffold(
          body: GestureDetector(
            onLongPressStart: (_){
    if (_videoPlayerController!.value.isPlaying) {
    _videoPlayerController!.pause();
    _animationController!.stop();

    };},
            onLongPressEnd: (_){
    if (_videoPlayerController!.value.isPlaying) {

    _videoPlayerController!.play();
              _animationController!.forward();
            };},
            onTapDown: (details) => _onTapDown(details, currentStory),
            child: Stack(
              children:[ PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: widget.stories.length,
                  itemBuilder: (context, i) {
                    final StoryModel story = widget.stories[i];
                    print(story.media_url);


                    switch (story.media_type) {
                      case "image":
                        return Stack(children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: CachedNetworkImage(
                              imageUrl: story.media_url,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              height: MediaQuery.of(context).size.height * 0.12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.picture))),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Positioned(
                            top: 60,
                            left: MediaQuery.of(context).size.width * 0.21,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Text(
                                widget.userName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]);
                      case "video":


                          return Stack(
                            children: [
                              (_videoPlayerController!=null && _videoPlayerController!.value.isInitialized)?SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: VideoPlayer(_videoPlayerController!)):Center(child: CircularProgressIndicator(color: Colors.black,),),
                              Positioned(
                                top: 20,
                                left: 20,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.12,
                            height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: NetworkImage(widget.picture))),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Positioned(
                                top: 60,
                                left: MediaQuery.of(context).size.width * 0.21,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Text(
                                    widget.userName,
                                    style: TextStyle(
                                        color: Colors.white30,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Positioned(
                                top: 50,
                                right: MediaQuery.of(context).size.width * 0.1,
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: IconButton(
                                      onPressed: _toggleMute,
                                      icon: Icon(
                                        _isMuted
                                            ? Icons.volume_off
                                            : Icons.volume_up,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                    }
                  ),
                Positioned(
                  top:40,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: widget.stories.asMap().map((i,e){
                      return MapEntry(i, AnimatedBar(animeController: _animationController!,

                        position: i,currentIndex: _currentIndex,
                      ));
                    }).values.toList()
                  ),
                )
            ],),
          ),
        ));
  }

  void _onTapDown(TapDownDetails details, StoryModel story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      // tapped left of screen
      setState(() {
        if (_currentIndex - 1 >= 0) {
         _currentIndex -= 1;
          loadStory(story: widget.stories[_currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {

      setState(() {
        if (_currentIndex + 1 < widget.stories.length) {
          // tapped right of screen
          _currentIndex += 1;
          loadStory(story: widget.stories[_currentIndex]);
        } else {
          //out of bound index
          _currentIndex = 0;
          loadStory(story: widget.stories[_currentIndex]);
        }
      });
    } else {
      //tapped in middle of screen
      if(story.media_type=="video")
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController!.pause();
        _animationController!.stop();

      } else {
        _videoPlayerController!.play();
        _animationController!.forward();
      }
    }
  }

  void loadStory({StoryModel? story, bool animatPage = true}) {
    _animationController!.stop();
    _animationController!.reset();

    switch (story!.media_type) {
      case "image":
        _animationController!.duration = Duration(
            days: 0,
            hours: 0,
            minutes: 0,
            seconds: 6,
            microseconds: 6,
            milliseconds: 6);
        _animationController!.forward();
        break;

      case "video":
        _videoPlayerController!.dispose();
        _videoPlayerController = null;
        Uri videoUrl = Uri.parse(story.media_url);
        _videoPlayerController = VideoPlayerController.networkUrl(videoUrl)
          ..initialize().then((_) {
            setState(() {
              if (_videoPlayerController!.value.isInitialized) {
                _animationController!.duration =
                    _videoPlayerController!.value.duration;
                _videoPlayerController!.play();
                _animationController!.forward();
              }
            });
          }).catchError((error){
            setState(() {
              isVideoInitialised=false;
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(title:Text("Error"),
                content:Text("Video failed to load"),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text("Ok"))
                  ],
                );
            });
          }
            );});
        break;
    }
    if (animatPage) {
      //if animatePage is true,move to previous or next page
      _pageController!.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
    }
  }
}

class AnimatedBar extends StatelessWidget{
  final AnimationController animeController;
  final int currentIndex;
  final int position;

  AnimatedBar({
    Key? key,
    required this.animeController,
    required this.currentIndex,
    required this.position

}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Flexible(
    child:Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(builder: (context, constraints){
          return Stack(
            children: [
            buildContainer(
              double.infinity,
              position<currentIndex?Colors.white:Colors.white.withOpacity(0.5),
            )  ,
              position==currentIndex?
                  AnimatedBuilder(animation: animeController,
                      builder: (context,child){
                    return buildContainer(
                      constraints.maxWidth*animeController.value,
                      Colors.white,
                    );
                      }):SizedBox.shrink()
            ],
          );
        }),
    )
    );
  }
  
  Container buildContainer(double width, Color color){
    return Container(
      height: 5,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(3)
      ),
    );
  }
}
