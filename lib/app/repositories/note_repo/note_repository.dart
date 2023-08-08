import 'package:notes_app/app/models/NoteModel.dart';
import 'package:notes_app/app/repositories/note_repo/note_interface.dart';

import '../../core/db/DatabaseController.dart';

class NoteRepository extends INoteRepositories{
  final DatabaseController dbController = DatabaseController();

  @override
  Future<void> delete(int id) async{
    await dbController.deleteNoteRow(id);
  }

  @override
  Future<List<NoteModel>> getAll() async{
   return  await  dbController.getAllNotes();
  }

  @override
  Future<NoteModel?> getOne(int id) async{

    return await dbController.searchNote(id);
  }

  @override
  Future<void> insert(NoteModel noteModel) async{
     await dbController.createNoteRow(noteModel);

  }

  @override
  Future<void> update(NoteModel noteModel) async{
    await dbController.updateNoteRow(noteModel);

  }
}