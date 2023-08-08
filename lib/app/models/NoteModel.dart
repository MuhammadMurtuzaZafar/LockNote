class NoteModel{
  int? dbId;
  String? title;
  String? subTitle;
  int? isLock=0;///0 =unlock and 1=lock
  String? timestamp;

  NoteModel({this.dbId, this.title, this.subTitle, this.isLock, this.timestamp});

  NoteModel.fromMap(Map<String, dynamic> data)
      : dbId = data['id'],
        title = data['title'],
        subTitle = data['subTitle'],
        isLock = data['isLock'],
        timestamp = data['timeStamp'];

  Map<String,dynamic> toMap()=>{"id":dbId,"title":title,"subTitle":subTitle,"isLock":isLock};

}