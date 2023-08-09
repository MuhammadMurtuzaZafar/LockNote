import 'dart:typed_data';

class NoteModel{
  int? dbId;
  String? title;
  String? subTitle;
  int? isLock=0;///0 =unlock and 1=lock
  String? timestamp;
  List<int>? imageBinaryData;

  NoteModel({this.dbId, this.title, this.subTitle, this.isLock, this.timestamp,this.imageBinaryData});

  NoteModel.fromMap(Map<String, dynamic> data)
      : dbId = data['id'],
        title = data['title'],
        subTitle = data['subTitle'],
        isLock = data['isLock'],
        imageBinaryData = data['imageBinaryData'],
        timestamp = data['timeStamp'];

  Map<String,dynamic> toMap()=>{"id":dbId,"title":title,
    "subTitle":subTitle,"isLock":isLock,"imageBinaryData":Uint8List.fromList(imageBinaryData!)};

}