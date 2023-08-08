import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/app/core/utils/constants.dart';

import 'CustomSearch.dart';


AppBar CustomAppBar(
    {required BuildContext context,bloc}) {

  return AppBar(
      centerTitle: true,
      title: const Text(ConstantValues.title),
      actions:  [
        IconButton(onPressed: (){
          showSearch(context: context,
              delegate: CustomSearch(context,bloc));

        }, icon:  const Icon(Icons.search))
      ],
      elevation: 10);
}