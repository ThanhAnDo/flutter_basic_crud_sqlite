import 'package:flutter/material.dart';
import 'package:flutter_crud_sqlite/data/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //khai báo list để hiển thị data lên trang chủ
  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;
  //hàm refresh data hiển thị trên screen
  void _refreshData() async {
    final data = await SqlHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  //hàm mở modal add data
  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descController.text = existingData['desc'];
    }
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            top: 30,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Title"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Description"),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addData();
                  } else {
                    await _updateData(id);
                  }
                  _titleController.text = "";
                  _descController.text = "";
                  //ẩn modal bottom
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  print("Data added");
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    id == null ? "Add data" : "Update",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //hàm add data trên screen
  Future<void> _addData() async {
    await SqlHelper.createData(_titleController.text, _descController.text);
    _refreshData();
  }

  //hàm update data trên screen
  Future<void> _updateData(int id) async {
    await SqlHelper.updateData(id, _titleController.text, _descController.text);
    _refreshData();
  }

  //hàm delete data trên screen
  Future<void> _deleteData(int id) async {
    await SqlHelper.deleteData(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.red,
      content: Text('Data deleted'),
    ));
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEAF4),
      appBar: AppBar(
        title: const Text('CRUD data example'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      _allData[index]['title'],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  subtitle: Text(_allData[index]['desc']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showBottomSheet(_allData[index]['id']);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.indigo,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteData(_allData[index]['id']);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton:
          FloatingActionButton(onPressed: () => showBottomSheet(null)),
    );
  }
}
