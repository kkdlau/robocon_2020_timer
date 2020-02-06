import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class HistoryDialog extends StatefulWidget {
  HistoryDialog({Key key}) : super(key: key);

  @override
  _HistoryDialogState createState() => _HistoryDialogState();
}

class _HistoryDialogState extends State<HistoryDialog> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text('History'),
          titleTextStyle: Theme.of(context).textTheme.headline4,
          content: FutureBuilder(
            future: http
                .get('http://kkdlau.student.ust.hk/record.php?password=3211'),
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<String> files = snapshot.data.body.split(' ');
                  files.removeLast();
                  if (files.length == 0)
                    return Text(
                        'You are too lazy! Practise more!\n(Cannot find any files in server.)');
                  else
                    return SizedBox(
                      width: constraints.maxWidth * 0.4,
                      height: constraints.maxHeight * 0.4,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: <Widget>[
                                Text(
                                  files[index],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                IconButton(
                                  color: Colors.white,
                                  icon: Icon(Icons.visibility),
                                  onPressed: () {
                                    http
                                        .get(
                                            'http://kkdlau.student.ust.hk/download.php?path=' +
                                                files[index])
                                        .then((onValue) {
                                      if (onValue.statusCode == 200) {
                                        Navigator.pop(context, onValue.body);
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  color: Colors.blue,
                                  icon: Icon(Icons.cloud_download),
                                  onPressed: () {
                                    html.window.open(
                                        'http://kkdlau.student.ust.hk/download.php?path=' +
                                            files[index] +
                                            '&isDownload=true',
                                        'name');
                                  },
                                ),
                                IconButton(
                                  color: Colors.red,
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    http
                                        .get(
                                            'http://kkdlau.student.ust.hk/delete.php?path=' +
                                                files[index])
                                        .then((onValue) {
                                      setState(() {});
                                    });
                                  },
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    );
                } else {
                  return Text('Oops! Something is wrong!\n' +
                      snapshot.error.toString());
                }
              }
              return UnconstrainedBox(
                child: CircularProgressIndicator(),
              );
            },
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Close'),
              onPressed: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
