import 'dart:async';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import "package:on_audio_query/on_audio_query.dart";
import "package:permission_handler/permission_handler.dart";
//import 'package:awesome_notifications/awesome_notifications.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  init() {}
  
}
//sdbsdjvsjhjhhhhh
//kjhkjh
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 bool appBarSearch=false;
 final _audio_query= new OnAudioQuery();
 final player=AudioPlayer();
 List<SongModel>? filterList=[];
 List<SongModel>? songList=[];
 int intIndex=0;
 bool onselect=false;
 bool bottomPage=false;
 String sName="<unKnown>";
 String aName="<unKnown>";
 bool isplaying=false;
 SwiperController sController=SwiperController();
 Duration duration= const Duration();
 Duration position= const Duration();
 bool isSelected=false;
 final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
static final NotificationService _notificationService =
      NotificationService._internal();

 
  NotificationDetails? get  platformChannelSpecifics => 
  NotificationDetails(android: androidPlatformChannelSpecifics);
  
  get androidPlatformChannelSpecifics => AndroidNotificationDetails(
       intIndex as String,   //Required for Android 8.0 or after
       " channel name", //Required for Android 8.0 or after
        channelDescription: "String", //Required for Android 8.0 or after
        importance: Importance.max,
        priority: Priority.max
    );


@override
void initState() {
  initialize();
  super.initState();
  
}


@override
void dispose() {
  player.stop();
  super.dispose();
}


initialize() async { 
     var mStatus =await Permission.storage.request();
     if (mStatus!= PermissionStatus.granted){
      Permission.storage.request();
     // throw "permission revoked";
    }
}



Future<void> init() async {
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  
  const AndroidNotificationDetails androidPlatformChannelSpecifics = 
    AndroidNotificationDetails(
       " channel id",   //Required for Android 8.0 or after
       " channel name", //Required for Android 8.0 or after
        channelDescription: "String", //Required for Android 8.0 or after
        importance: Importance.max,
        priority: Priority.max,
    
    );
    const NotificationDetails platformChannelSpecifics = 
  NotificationDetails(android: androidPlatformChannelSpecifics);
    final InitializationSettings initializationSettings =
        InitializationSettings(  
            android: initializationSettingsAndroid, 
            iOS: null, 
            macOS: null);
            await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        );
  }

  Future selectNotification(String payload) async {
      //Handle notification tapped logic here
   }  


searchSong(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border:Border.all(color: Colors.white)
      ),
      child: Padding(
        padding: const EdgeInsets.only(left:10),
        child: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintStyle:TextStyle(color: Colors.grey),
            counterStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            hintText: "   Search Songs",
          ),
          keyboardType:TextInputType.text,
          onChanged: (value) => onsearch(value) ,
        ),
      ),
    );
  }

onsearch(String search ){

   if(search.isEmpty){
    setState(() {
      filterList=songList;
    });
    }
    else{
       setState(() {
  filterList=songList!.where((user) => 
   user.displayNameWOExt.toString().toLowerCase().contains(search.toLowerCase())).toList();
});
      }
    }

  filteredShow(){
    return ListView.builder(
      itemCount: filterList!.length,
      itemBuilder: (BuildContext context, int index) {
        return  Padding(
             padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
             child: Container(
              decoration: BoxDecoration(
              border:BorderDirectional(
                bottom: BorderSide(color: Colors.grey,
                )
              )
             ),
               child: ListTile(
                onTap: (){
                  for (int i=0;i<songList!.length;i++){
                    if(songList![i]==filterList![index]){
                      setState(() {
                        intIndex=i;
                        appBarSearch=false;
                         onselect=true;
                          bottomPage=false;
                          sName=songList![intIndex].displayNameWOExt;
                          aName=songList![intIndex].artist!;
                          isplaying=true;
                      });
                    }
                  }
                  playerfun(intIndex);
                },
                selected: isSelected,
                trailing:onselect? index==intIndex?Icon(Icons.multitrack_audio,color:isplaying?  Colors.amber:Colors.white,):null :null,
                leading:CircleAvatar(
                  child: QueryArtworkWidget(id: filterList![index].id,
                  keepOldArtwork: true,
                   type: ArtworkType.AUDIO,
                   nullArtworkWidget: Icon(Icons.music_note_sharp,color: Colors.black26,),),
                ),
                 title:Text(filterList![index].displayNameWOExt,style: TextStyle(color: Colors.white),maxLines: 1,),
                 subtitle:Text(filterList![index].artist!,style: TextStyle(color: Colors.grey),maxLines: 1,), 
               ),
             ),
           );
      },
    );
  }

 
  SongList() {
    return
  FutureBuilder<List<SongModel>>(
    future:_audio_query.querySongs(
    orderType: OrderType.ASC_OR_SMALLER,
    ignoreCase: true,
    uriType: UriType.EXTERNAL,
    ),
    builder: (BuildContext context, items) {
      if(items.data==null){  
        return Center(child: RefreshProgressIndicator());
      }else if(items.data!.isEmpty){
        return Text("empty");
      }else{
        songList=items.data!;
     return  ListView.builder(
            itemCount:songList!.length,
            itemBuilder: 
      (BuildContext context ,index){
         return InkWell(
          onTap: () async {
            await flutterLocalNotificationsPlugin.show(
        intIndex, 
        "A Notification From My Application",
        "This notification was sent using Flutter Local Notifcations Package", 
        platformChannelSpecifics,
        payload:'fg'
        );
            // bool isallowed = await AwesomeNotifications().isNotificationAllowed();
            // if(!isallowed){
            //   AwesomeNotifications().requestPermissionToSendNotifications();
            //   print("eeeeeeeeeeeeee");
            // }
            // else{
            //   print("eeeeeerrrrrrrrrrr");
            //   AwesomeNotifications().createNotification(content: 
            //   NotificationContent(id: 123, channelKey: "basic",
            //   title: sName,
            //   body:isallowed? "fhhghghg":"fgcc"
            //   )
            //   );
          
            // }
            setState(() {
              onselect=true;
             // bottomPage=false;
               intIndex=index;
              sName=songList![intIndex].displayNameWOExt;
              aName=songList![intIndex].artist!;
               isplaying=true;
             });
             playerfun(index);
          },
           child: Padding(
             padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
             child: Container(
              decoration: BoxDecoration(
              border:BorderDirectional(
                bottom: BorderSide(color: Colors.grey,
                )
              )
             ),
               child: ListTile(
                selected: isSelected,
                trailing:onselect? index==intIndex?Icon(Icons.multitrack_audio,color:isplaying?  Colors.amber:Colors.white,):null :null,
                leading:CircleAvatar(
                  child: QueryArtworkWidget(id: songList![index].id,
                  keepOldArtwork: true,
                   type: ArtworkType.AUDIO,
                   nullArtworkWidget: Icon(Icons.music_note_sharp,color: Colors.black26,),),
                ),
                 title:Text(songList![index].displayNameWOExt,style: TextStyle(color: Colors.white),maxLines: 1,),
                 subtitle:Text(songList![index].artist!,style: TextStyle(color: Colors.grey),maxLines: 1,), 
               ),
             ),
           ),
        );
      }
    );
  }   }
 );
}


bottom(){
  return onselect? 
  BottomAppBar(
        child: AnimatedContainer(
           decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        colors: [Color.fromARGB(255, 9, 1, 34),Color.fromARGB(255, 79, 1, 42)])
         ),
            height:  bottomPage? 50:MediaQuery.of(context).size.height,
          duration: Duration(milliseconds: 300),
          child:bottomPage? GestureDetector(
            onPanUpdate: gesture(),
            child: Container(
           color: Color.fromARGB(255, 79, 1, 42),
              child: Column(
                children: [
                 Expanded(
                   child:slider()
                 ),
                  Container(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Expanded(
                     flex: 1,
                     child: CircleAvatar(child:imageS(),)),
                    Expanded(
                       flex: 2,
                      child: TextButton(
                        onPressed: () { setState(() {
                          bottomPage=false;
                        }); },
                        child: Scrollable(
                          viewportBuilder: (BuildContext context, ViewportOffset position) {   return Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(sName,maxLines: 1,
                              textAlign:TextAlign.center,
                              style: TextStyle(fontWeight:FontWeight.w600,color: Colors.white),),
                               Text(aName, maxLines: 1,style: TextStyle(color: Colors.white),
                              ),
                            ],
                          );},
                          //uyfyffhfhg
                          
                        ),
                      ),
                    ),
                Expanded(
                     flex: 2,
                   child: Row( 
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       IconButton(onPressed: (){preFun();
                       }, icon: Icon(Icons.skip_previous,color: Colors.grey,)),
                       isplaying? IconButton(onPressed: (){pausefun();
                       setState(() {
                         isplaying=false;
                       });}, icon: Icon(Icons.pause,color: Colors.grey))
                       :IconButton(onPressed: (){playerfun(intIndex);
                       setState(() {
                         isplaying=true;
                       });}, icon: Icon(Icons.play_arrow,color: Colors.grey)),        
                       IconButton(onPressed: (){nextFun();
                       setState(() {
                         isplaying=true;
                          sName=songList![intIndex].displayNameWOExt;
                          aName=songList![intIndex].artist!;
                                });}, icon: Icon(Icons.skip_next,color: Colors.grey))              
                              ],
                            ),
                          ),
                         ],),
                   ),
                ],
              ),
            ),
          ):SingleChildScrollView(
            child: GestureDetector(
              onPanUpdate: gesture(),
              child: Container(
                 height:MediaQuery.of(context).size.height,
                width:MediaQuery.of(context).size.width,   
                child: next(),
              ),
            ),
          )
        ),
      ):BottomAppBar();
}

gesture(){
  return (details) {
  RangeError("ihfihifhifid");
             // if(details.delta.dx==null){return ;};
           if (bottomPage=false) {
              if(details.delta.dx>-8){nextFun();};
              if(details.delta.dx<8){preFun();};
            }
            if(details.delta.dy>8){setState(() {
              bottomPage=true;
            });}
             if(details.delta.dy<-8){setState(() {
              bottomPage=false;
            });}
        };}

imageS(){
 return  QueryArtworkWidget(id: songList![intIndex].id,
                  keepOldArtwork: true,
                   type: ArtworkType.AUDIO,
                   nullArtworkWidget: Icon(Icons.music_note_sharp,color: Colors.black26,),);
}


slider(){ if((position.toString())==(duration.toString())&&(duration.toString()!="0:00:00.000000")){
    nextFun();
    print("aaaaaaaaaaaa $position $duration");
  }
 
  return SliderTheme(
                   data: SliderThemeData(
                    thumbShape: SliderComponentShape.noThumb,
                    trackHeight: 1
                   ),
                   child: Slider(
                   inactiveColor:Colors.grey ,
                    //overlayColor: MaterialStatePropertyAll(Colors.grey),
                    activeColor: Colors.amber,
                     min:Duration(milliseconds: 0).inSeconds.toDouble(),
                     value: position.inSeconds.toDouble(),
                     max:duration.inSeconds.toDouble(),
                     onChanged: (value) {
                      
                     setState(() {
                         change(value.toInt());
                         value=value;
                       });
                   },),
                 );
               }
 void change(int seconds) {
      Duration duration= Duration(seconds: seconds);
      player.seek(duration);
     }


playerfun(int index){
    player.durationStream.listen((d) { 
      setState(() {
         Timer(Duration(seconds: 0), () {duration=d!;});
      });
    });
       player.positionStream.listen((p) {
      setState(() {
        position=p;
      });
    });
   
        try {
      player.setAudioSource(AudioSource.uri(Uri.parse((songList![index]).uri!)));
      player.play();
      } on Exception catch (e) {
        print("uri parse error");
      }
      }
    pausefun(){
      player.pause();
    }
    resfun(){
    //  player.()
    }
  nextFun(){
    setState(() {
     if(-1<intIndex && intIndex<((songList!.length)-1)){ 
      intIndex=intIndex+1;
    }
      isplaying=true;
      sName=songList![intIndex].displayNameWOExt;
      aName=songList![intIndex].artist!;
    });
  playerfun(intIndex);
  scrollIndex(intIndex+1);
  }
  preFun(){
    setState(() {
      if(0<intIndex && intIndex<((songList!.length))){
              intIndex=intIndex-1;}
              sName=songList![intIndex].displayNameWOExt;
              aName=songList![intIndex].artist!;
              isplaying=true;
    });
    playerfun(intIndex);
    scrollIndex(intIndex-1);
  }


next() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Center(
          child: IconButton(onPressed: (){
            setState(() {
          bottomPage=true;
        });
          }, icon: Icon(Icons.keyboard_arrow_down_sharp,color: Colors.white,
          size: 40,)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0,50,0,50),
        child: Container(
        //  padding: EdgeInsets.all(16),
             height:MediaQuery.of(context).size.height/2.5,
                width:MediaQuery.of(context).size.width/1.1111,   
          child: nextImage(intIndex)
        ),
      ) ,
            Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(songList![intIndex].displayNameWOExt,
        textAlign: TextAlign.center,maxLines: 1,
        style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,color: Colors.white,),),
            ),
            Text(songList![intIndex].artist.toString(),
            textAlign: TextAlign.center,maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15,color: Colors.grey),), Padding(
          padding: const EdgeInsets.all( 20.0),
          child: Row(
           children: [
             Text(position.toString().split(".")[0],style: TextStyle(color: Colors.white60),),
           Expanded(child:slider()
               ),
                Text(duration.toString().split(".")[0],style: TextStyle(color: Colors.white60)),
           ],
          ),
        ),
        Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: (){preFun();
                    }, icon: Icon(Icons.skip_previous_rounded,size: 50,color: Colors.grey)),
                    isplaying? IconButton(onPressed: (){pausefun();
                    setState(() {
                      isplaying=false;
                    });}, icon: Icon(Icons.pause,size: 50,color: Colors.grey))
                    :IconButton(onPressed: (){playerfun(intIndex);
                    setState(() {
                      isplaying=true;
                    });}, icon: Icon(Icons.play_arrow,size: 50,color: Colors.grey)),
                     IconButton(onPressed: (){nextFun();}, icon: Icon(Icons.skip_next_rounded,size: 50,color: Colors.grey)),
                  ],
                ),
              ),
    ],
  );
}


nextImage(int intindex){
 return  Swiper( 
 controller: sController,
        index: intIndex,
        onIndexChanged: (value) {
          print(SwiperControl());
          if((intIndex-1)==(value)){
            preFun();
          }if((intIndex+1)==(value)){
            nextFun();
          }
             },
      itemCount: songList!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
             
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedContainer(
                   height:MediaQuery.of(context).size.height/2,
                   width:MediaQuery.of(context).size.width/1.1111,
                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                   gradient: SweepGradient(
                    colors: [Colors.white,Color.fromARGB(255, 9, 1, 34),Colors.white,Color.fromARGB(255, 79, 1, 42,),Colors.white])
                   ),
                   duration: Duration(seconds: 1),
                   child: QueryArtworkWidget(id: songList![index].id,
                   keepOldArtwork: true,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Icon(Icons.music_note_outlined,size: 100,color: Colors.white70,),),
                  ),
            ) ;
          },
      );
}

void scrollIndex(int intindex){
  sController.move(intIndex);
}



  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: BoxDecoration(
       gradient: LinearGradient(
        begin: Alignment.topCenter,
        colors: [Color.fromARGB(255, 9, 1, 34),Color.fromARGB(255, 79, 1, 42)])
     ),
     child: Scaffold(
       bottomNavigationBar: bottom(),
      backgroundColor:  Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
         elevation: 0,
          iconTheme: const IconThemeData(),
          title: !appBarSearch ?Text("Audio Player"):searchSong(),
          actions: [
            !appBarSearch?
            IconButton(onPressed: (){
              setState(() {
                appBarSearch=true;
              });
            }
            , icon: Icon(Icons.search,color: Colors.white,)):
             IconButton(icon: 
            Icon(Icons.clear,color:Colors.white),
            onPressed:(){
              setState((){
                filterList=songList;
                appBarSearch =false;
              });
            }
          ),
          // PopupMenuButton(
          //   itemBuilder: 
          // (context){
          //   return null;
          // }
          // )
        ]
      ),

      body: Container(
        child:!appBarSearch? SongList():filteredShow() ,
      ),


     ),
    );
  }
}

