import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:layout/pages/detail.dart';

import 'package:http/http.dart' as http; //as http คือตั้งชื่อเล่น อันนี้ไปติดตั้งที่ pubspec.yaml depedencies แล้ว
import 'dart:async';

class HomePage extends StatefulWidget {
  //const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แอพแนะนำขนม"),

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder( builder: (context, AsyncSnapshot snapshot) { //snapshot = ข้อมูลทั้งก้อน [{},{},{}] มาจาก future: ข้างล่าง ***** เพิ่ม AsyncSnapshot 
          //var data = json.decode(snapshot.data.toString()); //ต้อง import dart:convert    แปลงข้อมูลเป็นข้อความ
          return ListView.builder(  //คือแยกข้อมูลออกเป็นชุดๆ คล้ายๆกับการ run loop (สร้าง itemBuilder ในที่นี้คือ MyBox) ตามจำนวน itemCount
            itemBuilder: (BuildContext context, int index){
              return MyBox(snapshot.data[index]['title'], snapshot.data[index]['subtitle'], snapshot.data[index]['image_url'], snapshot.data[index]['detail']);
            },
            itemCount: snapshot.data.length, //ทำให้เพิ่มข้อมูลได้ใน json file เลย ไม่ต้องแก้ code
            );

        },
        future: getData(), //สร้างมาแทนการดึง assets/data.json ไปใช้ ที่เก็บใน github แทน
        //future: DefaultAssetBundle.of(context).loadString('assets/data.json'), 
        //ฟังก์ชั่นพิเศษ เกี่ยวกับการทำงาน 2 ฟังก์ชั่นพร้อมกัน ระหว่างสร้างหน้าแอป ก็ไป read json file ด้วย . concept asynchronous ใครเสร็จก่อนก็เสร็จไปเลย ไม่ต้องรอ
        //หลัง future คือเสมือนเอาข้อมูลใน json มาวางใน code เลย
        ),
      )
    );
  }




  Widget MyBox(String title, String subtitle, String image_url, String detail) {
    var v1,v2,v3,v4;
    v1 = title;
    v2 = subtitle;
    v3 = image_url;
    v4 = detail;
    return Container(
      margin: EdgeInsets.only(top : 20), //ถ้าไม่ใส่ แต่ละ MyBox จะติดๆกัน จากที่เราดึง json มาทั้งหมด
      padding: EdgeInsets.all(15),
      //color: Colors.blue[50],
      height:150,
      decoration: BoxDecoration(
        //color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(image_url), //ใส่รูปจาก web
          fit: BoxFit.cover, //ปรับขนาดรูปให้เต็มพอดีกับ container
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.darken) //ทำให้รูปภาพสีเข้มขึ้น
        )
      ),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),
          SizedBox(height: 15,),
          Text(
            subtitle, 
            style: TextStyle(fontSize: 10, color: Colors.white),),
          SizedBox(height: 5,),
          TextButton(onPressed: () {
            print("Next Page >>>");
            Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage(v1,v2,v3,v4)));
          }, 
            child: Text("อ่านต่อ")
          
          )
        ],
      ),
    );

  }


  Future getData() async {
    //https://raw.githubusercontent.com/TJessada/BasicAPI/main/data.json
    var url = Uri.https( 'raw.githubusercontent.com','/TJessada/BasicAPI/main/data.json' );
    var response = await http.get(url);
    var result = json.decode(response.body);
    return result;
  }

}