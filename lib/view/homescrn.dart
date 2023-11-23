import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class homescn extends StatefulWidget {
  const homescn({super.key});

  @override
  State<homescn> createState() => _homescnState();
}

class _homescnState extends State<homescn> {
  TextEditingController namecontroller = TextEditingController();
  List keylist = [];

  var box = Hive.box('myBox');
  @override
  void initState() {
    keylist = box.keys.toList();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Too Doo",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [Icon(Icons.more_vert)],
      ),
      body: ListView.builder(
        itemCount: keylist.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                color: Colors.indigo, borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  box.get(keylist[index])["title"],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      color: Colors.white),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          box.delete(keylist[index]);
                          keylist = box.keys.toList();
                          setState(() {});
                        },
                        icon: Icon(Icons.delete)),
                    SizedBox(
                      width: 10,
                    ),
                    Checkbox(
                      value: box.get(keylist[index])["iscompleted"],
                      onChanged: (value) {
                        box.put(keylist[index], {
                          "title": box.get(keylist[index])["title"],
                          "iscompleted": value
                        });
                        keylist = box.keys.toList();
                        setState(() {});
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          showModalBottomSheet(
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: namecontroller,
                        decoration: InputDecoration(
                            fillColor: Colors.blueGrey,
                            filled: true,
                            hintText: "username",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (namecontroller.text.isNotEmpty) {
                              box.add({
                                "title": namecontroller.text.trim(),
                                "iscompleted": false
                              });
                              keylist = box.keys.toList();
                              namecontroller.clear();
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Enter a valid output")));
                            }
                          },
                          child: Text("upload"))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
