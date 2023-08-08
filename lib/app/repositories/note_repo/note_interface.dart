
import 'package:notes_app/app/models/NoteModel.dart';


abstract class INoteRepositories{

  Future<List<NoteModel>> getAll();
  Future<NoteModel?> getOne(int id);
  Future<void> insert(NoteModel book);
  Future<void> update(NoteModel book);
  Future<void> delete(int id);
}