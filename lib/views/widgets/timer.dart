// import 'dart:async';
// import 'package:flutter/material.dart';

// class ResendOTPTimer extends StatefulWidget {
  
//   const ResendOTPTimer({Key? key}) : super(key: key);

//   @override
//   _ResendOTPTimerState createState() => _ResendOTPTimerState();
// }

// class _ResendOTPTimerState extends State<ResendOTPTimer> {
//   late Timer _timer;
//   Duration _timeRemaining = Duration(minutes: 1); // Total time for the timer

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       '${_formatDuration(_timeRemaining)}',
//       style: TextStyle(fontSize: 16.0),
//     );
//   }

//   // Function to start the timer
//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (_timeRemaining.inSeconds == 0) {
//           // Timer reached 0, stop the timer
//           timer.cancel();
//         } else {
//           // Decrease the timer by 1 second
//           setState(() {
//             _timeRemaining = _timeRemaining - oneSec;
//           });
//         }
//       },
//     );
//   }

//   // Function to format duration into HH:MM:SS
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$twoDigitSeconds";
//   }

//   @override
//   void dispose() {
//     _timer.cancel(); // Cancel the timer to avoid memory leaks
//     super.dispose();
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';

// class ResendOTPTimer extends StatefulWidget {
//   const ResendOTPTimer({Key? key}) : super(key: key);

//   @override
//   _ResendOTPTimerState createState() => _ResendOTPTimerState();
// }

// class _ResendOTPTimerState extends State<ResendOTPTimer> {
//   late Timer _timer;
//   Duration _timeRemaining = Duration(minutes: 1); // Total time for the timer

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       '${_formatDuration(_timeRemaining)}',
//       style: TextStyle(fontSize: 16.0),
//     );
//   }

//   // Function to start the timer
//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (_timeRemaining.inSeconds == 0) {
//           // Timer reached 0, stop the timer
//           timer.cancel();
//         } else {
//           // Decrease the timer by 1 second
//           setState(() {
//             _timeRemaining = _timeRemaining - oneSec;
//           });
//         }
//       },
//     );
//   }

//   // Function to reset the timer
//   void resetTimer() {
//     setState(() {
//       _timeRemaining = Duration(minutes: 1);
//     });
//     startTimer();
//   }

//   // Function to format duration into HH:MM:SS
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$twoDigitSeconds";
//   }

//   @override
//   void dispose() {
//     _timer.cancel(); // Cancel the timer to avoid memory leaks
//     super.dispose();
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';

class ResendOTPTimer extends StatefulWidget {
  const ResendOTPTimer({Key? key}) : super(key: key);

  @override
  ResendOTPTimerState createState() => ResendOTPTimerState();
}

class ResendOTPTimerState extends State<ResendOTPTimer> {
  late Timer _timer;
  Duration _timeRemaining = Duration(minutes: 1); // Total time for the timer

  // Method to start the timer
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeRemaining.inSeconds == 0) {
          // Timer reached 0, stop the timer
          timer.cancel();
        } else {
          // Decrease the timer by 1 second
          setState(() {
            _timeRemaining = _timeRemaining - oneSec;
          });
        }
      },
    );
  }

  // Method to reset the timer
  void resetTimer() {
    setState(() {
      _timeRemaining = Duration(minutes: 1);
    });
    startTimer();
  }

  // Method to format duration into HH:MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitSeconds sec";
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_formatDuration(_timeRemaining)}',
      style: TextStyle(fontSize: 16.0, color: Colors.red),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }
}
