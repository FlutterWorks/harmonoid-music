import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:harmonoid/core/collection.dart';
import 'package:harmonoid/core/playback.dart';
import 'package:harmonoid/utils/widgets.dart';
import 'package:harmonoid/constants/language.dart';

class CollectionTrackTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Collection>(
      builder: (context, collection, _) => collection.tracks.isNotEmpty
          ? CustomListView(
              children: () {
                List<Widget> children = <Widget>[];
                children.addAll([
                  SubHeader(language!.STRING_LOCAL_TOP_SUBHEADER_TRACK),
                  LeadingCollectionTrackTile(),
                  SubHeader(language!.STRING_LOCAL_OTHER_SUBHEADER_TRACK)
                ]);
                collection.tracks.asMap().forEach((int index, _) {
                  children.add(
                    CollectionTrackTile(
                      track: collection.tracks[index],
                      index: index,
                    ),
                  );
                });
                return children;
              }(),
            )
          : Center(
              child: ExceptionWidget(
                height: 256.0,
                width: 420.0,
                margin: EdgeInsets.zero,
                title: language!.STRING_NO_COLLECTION_TITLE,
                subtitle: language!.STRING_NO_COLLECTION_SUBTITLE,
              ),
            ),
    );
  }
}

class CollectionTrackTile extends StatelessWidget {
  final Track track;
  final int? index;
  const CollectionTrackTile({Key? key, required this.track, this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<Collection>(
      builder: (context, collection, _) => Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () => this.index != null
              ? Playback.play(
                  index: this.index!,
                  tracks: collection.tracks,
                )
              : Playback.play(
                  index: 0,
                  tracks: <Track>[this.track],
                ),
          dense: false,
          leading: CircleAvatar(
            child: Text(
              '${this.track.trackNumber ?? 1}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundImage: FileImage(this.track.albumArt),
          ),
          title: Text(
            this.track.trackName!,
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
          ),
          subtitle: Text(
            this.track.albumName! +
                ' • ' +
                (this.track.trackArtistNames!.length < 2
                    ? this.track.trackArtistNames!.join(', ')
                    : this.track.trackArtistNames!.sublist(0, 2).join(', ')),
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
          ),
          trailing: CollectionTrackContextMenu(
            track: this.track,
          ),
        ),
      ),
    );
  }
}

class LeadingCollectionTrackTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
      child: Consumer<Collection>(
        builder: (context, collection, _) => InkWell(
          onTap: () async => await Playback.play(
            index: 0,
            tracks: [collection.lastTrack!],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Ink.image(
                image: FileImage(collection.lastTrack!.albumArt),
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
                height: 156.0,
                width: (MediaQuery.of(context).size.width *
                        (Platform.isLinux ? 0.75 : 1.0)) -
                    16.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16.0, right: 16.0),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        child: Text(
                          '${collection.lastTrack!.trackNumber ?? 1}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundImage: FileImage(
                          collection.lastTrack!.albumArt,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Divider(
                            color: Colors.transparent,
                            height: 8.0,
                          ),
                          Text(
                            collection.lastTrack!.trackName!,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Text(
                            collection.lastTrack!.albumName!,
                            style: Theme.of(context).textTheme.headline3,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                          ),
                          Text(
                            collection.lastTrack!.trackArtistNames!.length < 2
                                ? collection.lastTrack!.trackArtistNames!
                                    .join(', ')
                                : collection.lastTrack!.trackArtistNames!
                                    .sublist(0, 2)
                                    .join(', '),
                            style: Theme.of(context).textTheme.headline3,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 16.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.play_arrow_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 28.0,
                        ),
                        onPressed: null,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
