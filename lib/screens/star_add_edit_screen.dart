import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../provider/star_provider.dart';
import '../models/star.dart';

class StarAddEditScreen extends StatefulWidget {
  static const routeName = '/add-edit';
  const StarAddEditScreen({Key? key}) : super(key: key);

  @override
  State<StarAddEditScreen> createState() => _StarAddEditScreenState();
}

class _StarAddEditScreenState extends State<StarAddEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _brightnessController;
  late TextEditingController _distanceController;
  late TextEditingController _sizeController;

  Star? _editingStar;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Star) {
      _editingStar = args;
    }

    _nameController = TextEditingController(text: _editingStar?.name ?? '');
    _brightnessController = TextEditingController(
      text: _editingStar?.brightness.toString() ?? '1.0',
    );
    _distanceController = TextEditingController(
      text: _editingStar?.distance.toString() ?? '0.0',
    );
    _sizeController = TextEditingController(
      text: _editingStar?.size.toString() ?? '1000',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brightnessController.dispose();
    _distanceController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final brightness = double.tryParse(_brightnessController.text) ?? 1.0;
    final distance = double.tryParse(_distanceController.text) ?? 0.0;
    final size = double.tryParse(_sizeController.text) ?? 1000.0;
    final dateNow = DateTime.now();

    final provider = context.read<StarProvider>();

    if (_editingStar == null) {
      provider.addStar(name, brightness, distance, size, dateNow);
    } else {
      final updated = Star(
        id: _editingStar!.id,
        name: name,
        brightness: brightness,
        distance: distance,
        size: size,
        imagePath: null,
        date: dateNow,
        isUserAdded: _editingStar!.isUserAdded,
      );
      provider.updateStar(_editingStar!.id!, updated);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingStar != null;
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text(isEditing ? 'แก้ไขดาว' : 'เพิ่มดาวใหม่'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: gradientAppBar),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 🔹 กล่องแสดงชื่อดาวแทนรูปภาพ
                Container(
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: kCardBackground,
                    border: Border.all(color: kPrimaryPurple.withOpacity(0.4)),
                  ),
                  child: Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text
                        : 'ยังไม่มีชื่อดาว',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 14),

                // 🔹 ช่องกรอกชื่อดาว (อัปเดตกล่องบนทันที)
                TextFormField(
                  controller: _nameController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'ชื่อดาว',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: kCardBackground,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'กรุณากรอกชื่อกลุ่มดาว'
                      : null,
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _brightnessController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Brightness',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: kCardBackground,
                        ),
                        validator: (v) => double.tryParse(v ?? '') == null
                            ? 'ใส่ค่าเป็นตัวเลข'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _distanceController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Distance (ly)',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: kCardBackground,
                        ),
                        validator: (v) => double.tryParse(v ?? '') == null
                            ? 'ใส่ค่าเป็นตัวเลข'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 🔹 เปลี่ยนจาก Size (km) เป็น "จำนวนดาว"
                TextFormField(
                  controller: _sizeController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'จำนวนดาวที่มองเห็น',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: kCardBackground,
                  ),
                  validator: (v) => double.tryParse(v ?? '') == null
                      ? 'ใส่ค่าเป็นตัวเลข'
                      : null,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'บันทึกการแก้ไข' : 'เพิ่มดาว',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
