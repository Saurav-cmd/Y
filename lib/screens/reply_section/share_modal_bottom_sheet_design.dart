import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utility/colors.dart';

enum socialMedia { facebook, twitter, email }

class ShareBottomDesign extends StatefulWidget {
  ShareBottomDesign(
      {Key, this.title, this.description, this.name, this.category, key})
      : super(key: key);
  String? title;
  String? description;
  String? name;
  String? category;

  @override
  State<ShareBottomDesign> createState() => _ShareBottomDesignState();
}

class _ShareBottomDesignState extends State<ShareBottomDesign> {
  String? passedTitle;
  String? passedDescription;
  String? passedName;
  String? passedCategory;

  Future share(socialMedia socialPlatform) async {
    final subject = "$passedTitle";
    final text = "$passedDescription";
    final urlShare = Uri.encodeComponent('https://bihanitech.com/');

    final urls = {
      socialMedia.facebook:
          "https://www.facebook.com/sharer/sharer.php?u=$urlShare&quote=$subject!",
      socialMedia.twitter:
          'https://twitter.com/intent/tweet?url=$urlShare&text=$text'
    };

    final url = urls[socialPlatform]!;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passedTitle = widget.title;
    passedDescription = widget.description;
    passedName = widget.name;
    passedCategory = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.020, left: size.width * 0.030),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("images/Ellipse 3.png"),
                ),
                SizedBox(width: size.width * 0.020),
                Text(
                  "$passedName",
                  style: TextStyle(
                      fontSize: size.height * 0.015 + size.width * 0.015,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(height: size.height * 0.010),
          Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.020,
                left: size.width * 0.030,
                right: size.width * 0.030),
            child: Stack(
              children: [
                Form(
                    child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: "Say something about this share..",
                      hintStyle: TextStyle(
                          fontSize: size.height * 0.014 + size.width * 0.014)),
                  validator: (value) {
                    if (value == null) {
                      return "Please ask your question";
                    } else {
                      return null;
                    }
                  },
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => share(socialMedia.facebook),
                  icon: const Icon(Icons.facebook),
                  color: Colors.blue,
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: () => share(socialMedia.twitter),
                  icon: const FaIcon(FontAwesomeIcons.twitter),
                  iconSize: 40,
                  color: Colors.blue,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Share Now"),
                  style: ElevatedButton.styleFrom(
                      primary: ChooseColor(0).pinkColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
