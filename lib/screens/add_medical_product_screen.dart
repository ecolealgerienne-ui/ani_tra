// lib/screens/add_medical_product_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medical_product_provider.dart';
import '../models/medical_product.dart';

class AddMedicalProductScreen extends StatefulWidget {
  final String? productId; // null pour ajout, ID pour modification

  const AddMedicalProductScreen({
    super.key,
    this.productId,
  });

  @override
  State<AddMedicalProductScreen> createState() =>
      _AddMedicalProductScreenState();
}

class _AddMedicalProductScreenState extends State<AddMedicalProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _commercialNameController = TextEditingController();
  final _activeIngredientController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _dosageController = TextEditingController();
  final _dosageUnitController = TextEditingController();
  final _withdrawalMeatController = TextEditingController();
  final _withdrawalMilkController = TextEditingController();
  final _currentStockController = TextEditingController();
  final _minStockController = TextEditingController();
  final _stockUnitController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _batchNumberController = TextEditingController();
  final _storageConditionsController = TextEditingController();
  final _prescriptionController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Antibiotique';
  String _selectedForm = 'Injectable';
  DateTime? _selectedExpiryDate;

  bool _isLoading = false;

  final List<String> _categories = [
    'Antibiotique',
    'Anti-inflammatoire',
    'Antiparasitaire',
    'Vaccin',
    'Corticoïde',
    'Analgésique',
    'Hormone',
    'Vitamine',
    'Autre',
  ];

  final List<String> _forms = [
    'Injectable',
    'Oral',
    'Topique',
    'Intramamaire',
    'Pour-on',
    'Bolus',
    'Poudre',
    'Autre',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProductData();
    } else {
      // Valeurs par défaut pour un nouveau produit
      _withdrawalMeatController.text = '0';
      _withdrawalMilkController.text = '0';
      _minStockController.text = '10';
      _stockUnitController.text = 'ml';
      _dosageUnitController.text = 'mg/ml';
    }
  }

  void _loadProductData() {
    final provider = context.read<MedicalProductProvider>();
    final product = provider.getProductById(widget.productId!);

    if (product != null) {
      _nameController.text = product.name;
      _commercialNameController.text = product.commercialName ?? '';
      _selectedCategory = product.category;
      _activeIngredientController.text = product.activeIngredient ?? '';
      _manufacturerController.text = product.manufacturer ?? '';
      _selectedForm = product.form ?? 'Injectable';
      _dosageController.text = product.dosage?.toString() ?? '';
      _dosageUnitController.text = product.dosageUnit ?? '';
      _withdrawalMeatController.text = product.withdrawalPeriodMeat.toString();
      _withdrawalMilkController.text = product.withdrawalPeriodMilk.toString();
      _currentStockController.text = product.currentStock.toString();
      _minStockController.text = product.minStock.toString();
      _stockUnitController.text = product.stockUnit;
      _unitPriceController.text = product.unitPrice?.toString() ?? '';
      _batchNumberController.text = product.batchNumber ?? '';
      _selectedExpiryDate = product.expiryDate;
      _storageConditionsController.text = product.storageConditions ?? '';
      _prescriptionController.text = product.prescription ?? '';
      _notesController.text = product.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commercialNameController.dispose();
    _activeIngredientController.dispose();
    _manufacturerController.dispose();
    _dosageController.dispose();
    _dosageUnitController.dispose();
    _withdrawalMeatController.dispose();
    _withdrawalMilkController.dispose();
    _currentStockController.dispose();
    _minStockController.dispose();
    _stockUnitController.dispose();
    _unitPriceController.dispose();
    _batchNumberController.dispose();
    _storageConditionsController.dispose();
    _prescriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.productId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Modifier le produit' : 'Ajouter un produit'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Section: Informations générales
            _buildSectionTitle('Informations générales'),
            _buildTextField(
              controller: _nameController,
              label: 'Nom générique *',
              hint: 'Ex: AMOXICILLINE',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le nom est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _commercialNameController,
              label: 'Nom commercial',
              hint: 'Ex: Clamoxyl',
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              value: _selectedCategory,
              label: 'Catégorie *',
              items: _categories,
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _activeIngredientController,
              label: 'Principe actif',
              hint: 'Ex: Amoxicilline trihydrate',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _manufacturerController,
              label: 'Fabricant',
              hint: 'Ex: Zoetis',
            ),

            const SizedBox(height: 24),

            // Section: Forme et dosage
            _buildSectionTitle('Forme et dosage'),
            _buildDropdown(
              value: _selectedForm,
              label: 'Forme',
              items: _forms,
              onChanged: (value) {
                setState(() => _selectedForm = value!);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _dosageController,
                    label: 'Dosage',
                    hint: '150',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _dosageUnitController,
                    label: 'Unité',
                    hint: 'mg/ml',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section: Délais d'attente
            _buildSectionTitle('Délais d\'attente (jours)'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _withdrawalMeatController,
                    label: 'Viande *',
                    hint: '14',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requis';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Nombre invalide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _withdrawalMilkController,
                    label: 'Lait *',
                    hint: '3',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requis';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Nombre invalide';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section: Stock
            _buildSectionTitle('Stock et prix'),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _currentStockController,
                    label: 'Stock actuel *',
                    hint: '25',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requis';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Nombre invalide';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _stockUnitController,
                    label: 'Unité *',
                    hint: 'ml',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requis';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _minStockController,
              label: 'Stock minimum *',
              hint: '10',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le stock minimum est requis';
                }
                if (double.tryParse(value) == null) {
                  return 'Nombre invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _unitPriceController,
              label: 'Prix unitaire (EUR)',
              hint: '12.50',
              keyboardType: TextInputType.number,
              prefixText: '€ ',
            ),

            const SizedBox(height: 24),

            // Section: Lot et péremption
            _buildSectionTitle('Lot et péremption'),
            _buildTextField(
              controller: _batchNumberController,
              label: 'Numéro de lot',
              hint: 'LOT2024-A123',
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('Date d\'expiration'),
              subtitle: Text(
                _selectedExpiryDate != null
                    ? '${_selectedExpiryDate!.day}/${_selectedExpiryDate!.month}/${_selectedExpiryDate!.year}'
                    : 'Non définie',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _selectExpiryDate,
            ),
            const Divider(),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _storageConditionsController,
              label: 'Conditions de conservation',
              hint: 'Conserver entre 2°C et 8°C',
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // Section: Informations complémentaires
            _buildSectionTitle('Informations complémentaires'),
            _buildTextField(
              controller: _prescriptionController,
              label: 'Prescription',
              hint: 'Ordonnance vétérinaire requise',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _notesController,
              label: 'Notes',
              hint: 'Informations additionnelles...',
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // Boutons d'action
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isEdit ? 'Enregistrer' : 'Ajouter le produit'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? prefixText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedExpiryDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _selectedExpiryDate = picked;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez corriger les erreurs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simuler un délai
    await Future.delayed(const Duration(milliseconds: 500));

    final provider = context.read<MedicalProductProvider>();
    final isEdit = widget.productId != null;

    final product = MedicalProduct(
      id: isEdit
          ? widget.productId!
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      commercialName: _commercialNameController.text.trim().isNotEmpty
          ? _commercialNameController.text.trim()
          : null,
      category: _selectedCategory,
      activeIngredient: _activeIngredientController.text.trim().isNotEmpty
          ? _activeIngredientController.text.trim()
          : null,
      manufacturer: _manufacturerController.text.trim().isNotEmpty
          ? _manufacturerController.text.trim()
          : null,
      form: _selectedForm,
      dosage: _dosageController.text.trim().isNotEmpty
          ? double.tryParse(_dosageController.text.trim())
          : null,
      dosageUnit: _dosageUnitController.text.trim().isNotEmpty
          ? _dosageUnitController.text.trim()
          : null,
      withdrawalPeriodMeat: int.parse(_withdrawalMeatController.text.trim()),
      withdrawalPeriodMilk: int.parse(_withdrawalMilkController.text.trim()),
      currentStock: double.parse(_currentStockController.text.trim()),
      minStock: double.parse(_minStockController.text.trim()),
      stockUnit: _stockUnitController.text.trim(),
      unitPrice: _unitPriceController.text.trim().isNotEmpty
          ? double.tryParse(_unitPriceController.text.trim())
          : null,
      currency: 'EUR',
      batchNumber: _batchNumberController.text.trim().isNotEmpty
          ? _batchNumberController.text.trim()
          : null,
      expiryDate: _selectedExpiryDate,
      storageConditions: _storageConditionsController.text.trim().isNotEmpty
          ? _storageConditionsController.text.trim()
          : null,
      prescription: _prescriptionController.text.trim().isNotEmpty
          ? _prescriptionController.text.trim()
          : null,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      createdAt: DateTime.now(),
      updatedAt: isEdit ? DateTime.now() : null,
    );

    if (isEdit) {
      provider.updateProduct(product);
    } else {
      provider.addProduct(product);
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Produit modifié avec succès'
                : 'Produit ajouté avec succès',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le produit'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer ce produit ? '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<MedicalProductProvider>()
                  .deleteProduct(widget.productId!);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close edit screen
              Navigator.pop(context); // Close detail screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produit supprimé'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
