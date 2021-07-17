import 'package:flutter/material.dart';

class MusicCard extends StatelessWidget {
  final String title;
  final String singer;
  final String coverUrl;

  const MusicCard(this.title, this.singer, this.coverUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                    image: NetworkImage(coverUrl), fit: BoxFit.fill)),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                singer,
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }
}
