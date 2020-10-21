import 'package:flutter/material.dart';
import 'package:uBookSharing/BackEnd/Datas.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailsPage extends StatefulWidget {
  final BookData bookData;

  const BookDetailsPage({Key key, @required this.bookData}) : super(key: key);
  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(widget.bookData.bookName),
          RaisedButton(
            elevation: 10,
            child: Icon(Icons.mail_outline),
            onPressed: () async {
              final Uri launchEmailData = Uri(
                  scheme: 'mailto',
                  path: widget.bookData.bookUploaderEmail,
                  query:
                      'subject=uBookSharing response&body=Hi ${widget.bookData.bookUploaderName},\n I\'m ${UserProfileData.name}. I\'m a student of ${UserProfileData.versityName}, department ${UserProfileData.dept}, year ${UserProfileData.admitted}. My registration number is ${UserProfileData.registrationNo}.\n Would you please share you book \'${widget.bookData.bookName}\'  with me. My personal phone Number is ${UserProfileData.phoneNum}. I currently live in ${UserProfileData.address}.\n Thanks for your contribution'
                  // queryParameters: {
                  //   'subject': 'uBookSharing+response ',
                  //   'body':
                  //       'Hi {lender name},\n I\'m ${UserProfileData.name}. I\'m a student of ${UserProfileData.versityName}, department ${UserProfileData.dept}, year${UserProfileData.admitted}. My registration no. ${UserProfileData.registrationNo}.\n Would you please share you book{book name}  with me. My personal phone No. ${UserProfileData.phoneNum}. I currently live in ${UserProfileData.address}. Thanks for your contribution'
                  // },

                  );
              String launchEmailUrl = launchEmailData.toString();
              if (await canLaunch(launchEmailUrl)) {
                await launch(launchEmailUrl);
              } else {
                print('hwwww');
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Can\'t send automated email. Try sending manually")));
              }
            },
          ),
        ],
      ),
    );
  }
}
