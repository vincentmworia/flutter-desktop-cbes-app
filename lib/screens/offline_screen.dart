import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const opMain = 0.9;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(

          gradient: LinearGradient(
            colors: [
              Colors.white,
              Theme.of(context).colorScheme.secondary.withOpacity(opMain),
              Theme.of(context).colorScheme.primary.withOpacity(opMain),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),

          // image: DecorationImage(image: AssetImage('Images/home3.jpg'),fit: BoxFit.cover)
      ),
      child: Center(
        child: Text(
          "OFFLINE",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: MediaQuery
                  .of(context)
                  .size
                  .width * 0.025,
              fontWeight: FontWeight.bold,
              fontSize: 100.0),
        ),
      ),
    );
  }
}
