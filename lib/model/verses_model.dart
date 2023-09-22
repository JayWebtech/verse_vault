import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class VerseData extends HiveObject {
  @HiveField(0)
  late String chapter;

  @HiveField(1)
  late String verseText;

  @HiveField(2)
  late String notes;
}

class VerseDataAdapter extends TypeAdapter<VerseData> {
  @override
  final int typeId = 0;

  @override
  VerseData read(BinaryReader reader) {
    return VerseData()
      ..chapter = reader.read()
      ..verseText = reader.read()
      ..notes = reader.read();
  }

  @override
  void write(BinaryWriter writer, VerseData obj) {
    writer.write(obj.chapter);
    writer.write(obj.verseText);
    writer.write(obj.notes);
  }
}
