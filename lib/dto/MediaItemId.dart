import 'package:audio_service/audio_service.dart';

import 'IsterMediaItem.dart';

class MediaItemId {
  final String serverName;
  final IsterMediaTypes isterMediaType;
  final String id;

  MediaItemId(this.serverName, this.isterMediaType, this.id);

  static MediaItemId byStringId(String id) {
    List<String> split = id.split(";");
    Iterable<IsterMediaTypes> typeList = IsterMediaTypes.values.where((element) => element.name == split[1]);
    if (typeList.isNotEmpty) {
      return MediaItemId(split[0], typeList.first, split[2]);
    }
    throw StateError("The given Id couldn't be parse: $id");
  }

  @override
  String toString() {
    return "$serverName;${isterMediaType.name};$id";
  }
}
