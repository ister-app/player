import 'package:flutter/material.dart';
import 'package:player/utils/LoginManager.dart';

import '../utils/ClientManager.dart';

class CarouselItemView extends StatelessWidget {
  const CarouselItemView(
      {super.key,
      required this.serverName,
      required this.title,
      required this.subTitle,
      this.imageUrl,
      this.progress});

  final String serverName;
  final String title;
  final String subTitle;
  final String? imageUrl;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        ClipRect(
          child: Container(
              decoration: BoxDecoration(color: Colors.grey),
              child: OverflowBox(
                maxWidth: width * 7 / 8,
                minWidth: width * 7 / 8,
                child: (imageUrl != null && imageUrl != '')
                    ? Image(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(
                          headers: LoginManager.getHeaders(serverName),
                          '${ClientManager.getHttpOrHttps(serverName)}://$serverName/images/$imageUrl/download',
                        ),
                      )
                    : Container(),
              )),
        ),
        Opacity(
            opacity: 0.8,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subTitle,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )),
        progress != null
            ? Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: progress,
                ))
            : Container(),
      ],
    );
  }
}
