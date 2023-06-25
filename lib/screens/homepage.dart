import 'package:flutter/material.dart';
import 'package:sampleee/database_helper.dart';
import 'package:sampleee/screens/taskpage.dart';
import 'package:sampleee/widgets.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  DatabaseHelper _dbHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                color: Color(0xFFFFFFFF),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: 32.0,
                              ),

                            child:  Image(
                              image: AssetImage('assets/images/logo.png'),
                              height: 60.0,
                              width: 60.0,
                            ),
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.circular(10.0),
                              //   boxShadow: [BoxShadow(
                              //     blurRadius: 10.0,
                              //   )]
                              // ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 32.0,
                                left: 15.0,
                              ),
                              child: Text(
                                  "TODOO",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF211551),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: FutureBuilder(
                            future: _dbHelper.getTasks(),
                            builder: (context, snapshot) {
                              return ScrollConfiguration(
                                behavior: NoGlowBehaviour(),
                                child: ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TaskPage(
                                                      task: snapshot.data![index],
                                                    )
                                            )
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: TaskCardWidget(
                                        title: snapshot.data![index]?.title,
                                        desc: snapshot.data![index]?.description,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        bottom: 24.0,
                        right: 0.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskPage(task: null,))
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            width: 60.0,
                            height: 60.0,
                            child: Image(
                              image: AssetImage(
                                  'assets/images/add_icon.png'
                              ),
                              height: 40.0,
                              width: 40.0,
                            ),
                            // decoration: BoxDecoration(
                            //   color: Colors.transparent,
                            //   borderRadius: BorderRadius.circular(20.0),
                            //   boxShadow: [BoxShadow(
                            //     blurRadius: 5.0,
                            //   )]
                            // ),
                          ),
                        )
                    )
                  ],
                )
            ),

        )
    );
  }
}
