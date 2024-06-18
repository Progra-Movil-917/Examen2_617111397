import 'package:flutter/material.dart';
import 'package:examen_2_617111397/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? selectedCenter;
  String? selectedDoctor;

  final List<String> ingredientes = ["Huevo", "Harina", "Manteca","Leche","Carne","Pollo"];
  final List<String> utencilios = ["Cuchillo", "Cuchara",""];

  void openNotes({String? docID, Map<String, dynamic>? existingData}) {
    if (existingData != null) {
      nameController.text = existingData['name'] ?? '';
      noteController.text = existingData['note'] ?? '';
      selectedCenter = existingData['center'];
      selectedDoctor = existingData['doctor'];
      dateController.text = existingData['date'] ?? '';
    } else {
      nameController.clear();
      noteController.clear();
      selectedCenter = null;
      selectedDoctor = null;
      dateController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agregue una receta', style: TextStyle(color: Colors.blueAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Descripcion',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCenter,
              decoration: InputDecoration(
                labelText: 'Ingredientes',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: ingredientes.map((center) {
                return DropdownMenuItem<String>(
                  value: center,
                  child: Text(center),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCenter = value;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedDoctor,
              decoration: InputDecoration(
                labelText: 'Doctor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: utencilios.map((doctor) {
                return DropdownMenuItem<String>(
                  value: doctor,
                  child: Text(doctor),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDoctor = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Fecha de preparacion',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
             onPressed: () {
              final newNote = {
                'name': nameController.text,
                'note': noteController.text,
                'center': selectedCenter ?? '',
                'doctor': selectedDoctor ?? '',
                'date': dateController.text,
                'timestamp': Timestamp.now(),
              };

              if (docID == null) {
                firestoreService.addNote(noteData: newNote);
              } else {
                firestoreService.updateNotes(docID, noteData: newNote);
              }
              nameController.clear();
              noteController.clear();
              selectedCenter = null;
              selectedDoctor = null;
              dateController.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Agregar receta"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu de recetas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNotes,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(data['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ingredientes: ${data['center']}'),
                        Text('Doctor: ${data['doctor']}'),
                        Text('Fecha de preparacion: ${data['date']}'),
                        Text('Descripcion: ${data['note']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openNotes(docID: docID, existingData: data),
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        ),
                        IconButton(
                          onPressed: () => firestoreService.deleteNotes(docID),
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Sin citas", style: TextStyle(fontSize: 18)),
            );
          }
        },
      ),
    );
  }
}
