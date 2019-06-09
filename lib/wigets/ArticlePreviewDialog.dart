import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news/localizations.dart';
import 'package:news/model/models.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlePreviewDialog extends StatelessWidget {
  final Article article;

  ArticlePreviewDialog(this.article) : super(key: Key(article.url));

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 8.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getWidget(),
              SizedBox(height: 16.0),
              Text(
                article.title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                article.description ?? '',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton.icon(
                        onPressed: () {
                          _launchURL(article.url);
                        },
                        label: Text(AppLocalizations.of(context).open),
                        icon: Icon(Icons.open_in_browser),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        Share.share(article.url);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getWidget() {
    if (article.urlToImage != null) {
      return FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: article.urlToImage,
        fit: BoxFit.cover,
        height: 160,
      );
    } else {
      return Center(
        child: Container(
          child: Icon(Icons.photo_camera),
          height: 160,
        ),
      );
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
