import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String? title;
  final String? desc;

  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 30.0,
      ),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0,
          ),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(80.0),
            boxShadow: [BoxShadow(
              blurRadius: 5.0,
            )]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "(Unnamed Task)",
                style: TextStyle(
                  color: Color(0xFF211551),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
              ),
              Text(desc ?? 'No Description Added.',
                  style: TextStyle(fontSize: 16.0, color: Color(0xFF86829D)),
              )
            ],
          )),
    );
  }
}
class TodoWidget extends StatelessWidget {
  final String? text;
  final bool isDone;
  TodoWidget({this.text, required this.isDone});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.only(
              right: 12.0,
            ),
            decoration: BoxDecoration(
              color: isDone ? Color(0xFF7349FE): Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: isDone ? null : Border.all(
                color: Color(0xFF86829D),
                width: 1.5
              )
                
            ),
            child: Image(
              image: AssetImage(
                'assets/images/check_icon.png'
              ),
              height: 20.0,
              width: 20.0,
            )
          ),
          Flexible(
            child: Text(
                text ?? "(Unnamed TODO)",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
              ),
            ),
          ),
        ],
      )
    );
  }
}
class NoGlowBehaviour extends ScrollBehavior{
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection){
        return child;
}
}