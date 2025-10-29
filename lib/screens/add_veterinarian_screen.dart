// lib/screens/add_veterinarian_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/veterinarian_provider.dart';
import '../models/veterinarian.dart';

class AddVeterinarianScreen extends StatefulWidget {
  final String? veterinarianId; // null pour ajout, ID pour modification

  const AddVeterinarianScreen({
    super.key,
    this.veterinarianId,
  });

  @override
  State<AddVeterinarianScreen> createState() => _AddVeterinarianScreenState();
}

class _AddVeterinarianScreenState extends State<AddVeterinarianScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _clinicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _workingHoursController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  final _emergencyFeeController = TextEditingController();
  final _notesController = TextEditingController();

  List<String> _selectedSpecialties = [];
  bool _isAvailable = true;
  bool _emergencyService = false;
  bool _isPreferred = false;
  int _rating = 5;

  bool _isLoading = false;

  final List<String> _availableSpecialties = [
    'Bovins',
    'Ovins',
    'Caprins',
    'Équins',
    'Porcins',
    'Volailles',
    'Chirurgie',
    'Médecine préventive',
    'Reproduction',
    'Nutrition',
    'Parasitologie',
    'Pathologie digestive',
    'Échographie',
    'Radiologie',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.veterinarianId != null) {
      _loadVeterinarianData();
    } else {
      // Valeurs par défaut
      _titleController.text = 'Dr.';
    }
  }

  void _loadVeterinarianData() {
    final provider = context.read<VeterinarianProvider>();
    final vet = provider.getVeterinarianById(widget.veterinarianId!);

    if (vet != null) {
      _firstNameController.text = vet.firstName;
      _lastNameController.text = vet.lastName;
      _titleController.text = vet.title ?? '';
      _licenseNumberController.text = vet.licenseNumber;
      _selectedSpecialties = List.from(vet.specialties);
      _clinicController.text = vet.clinic ?? '';
      _phoneController.text = vet.phone;
      _mobileController.text = vet.mobile ?? '';
      _emailController.text = vet.email ?? '';
      _addressController.text = vet.address ?? '';
      _cityController.text = vet.city ?? '';
      _postalCodeController.text = vet.postalCode ?? '';
      _isAvailable = vet.isAvailable;
      _emergencyService = vet.emergencyService;
      _workingHoursController.text = vet.workingHours ?? '';
      _consultationFeeController.text = vet.consultationFee?.toString() ?? '';
      _emergencyFeeController.text = vet.emergencyFee?.toString() ?? '';
      _notesController.text = vet.notes ?? '';
      _isPreferred = vet.isPreferred;
      _rating = vet.rating;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _titleController.dispose();
    _licenseNumberController.dispose();
    _clinicController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _workingHoursController.dispose();
    _consultationFeeController.dispose();
    _emergencyFeeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.veterinarianId != null;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(isEdit ? 'Modifier le vétérinaire' : 'Ajouter un vétérinaire'),
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
            // Section: Informations personnelles
            _buildSectionTitle('Informations personnelles'),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildTextField(
                    controller: _titleController,
                    label: 'Titre',
                    hint: 'Dr.',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _firstNameController,
                    label: 'Prénom *',
                    hint: 'Jean',
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
              controller: _lastNameController,
              label: 'Nom *',
              hint: 'Martin',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le nom est requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Section: Informations professionnelles
            _buildSectionTitle('Informations professionnelles'),
            _buildTextField(
              controller: _licenseNumberController,
              label: 'Numéro d\'ordre *',
              hint: 'VET-75-12345',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le numéro d\'ordre est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _clinicController,
              label: 'Cabinet/Clinique',
              hint: 'Clinique Vétérinaire Rurale',
            ),
            const SizedBox(height: 12),
            // Spécialités
            const Text(
              'Spécialités',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableSpecialties.map((specialty) {
                final isSelected = _selectedSpecialties.contains(specialty);
                return FilterChip(
                  label: Text(specialty),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSpecialties.add(specialty);
                      } else {
                        _selectedSpecialties.remove(specialty);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Section: Coordonnées
            _buildSectionTitle('Coordonnées'),
            _buildTextField(
              controller: _phoneController,
              label: 'Téléphone *',
              hint: '+33 1 23 45 67 89',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le téléphone est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _mobileController,
              label: 'Mobile',
              hint: '+33 6 12 34 56 78',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'contact@vet-clinique.fr',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _addressController,
              label: 'Adresse',
              hint: '15 Rue de la Ferme',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildTextField(
                    controller: _postalCodeController,
                    label: 'Code postal',
                    hint: '69000',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _cityController,
                    label: 'Ville',
                    hint: 'Lyon',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section: Disponibilité
            _buildSectionTitle('Disponibilité'),
            SwitchListTile(
              title: const Text('Disponible'),
              subtitle:
                  const Text('Le vétérinaire est actuellement disponible'),
              value: _isAvailable,
              onChanged: (value) {
                setState(() => _isAvailable = value);
              },
            ),
            SwitchListTile(
              title: const Text('Service d\'urgence'),
              subtitle: const Text('Propose des interventions d\'urgence'),
              value: _emergencyService,
              onChanged: (value) {
                setState(() => _emergencyService = value);
              },
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _workingHoursController,
              label: 'Horaires de travail',
              hint: 'Lun-Ven: 8h-18h, Sam: 8h-12h',
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // Section: Tarifs
            _buildSectionTitle('Tarifs (EUR)'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _consultationFeeController,
                    label: 'Consultation',
                    hint: '65',
                    keyboardType: TextInputType.number,
                    prefixText: '€ ',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _emergencyFeeController,
                    label: 'Urgence',
                    hint: '120',
                    keyboardType: TextInputType.number,
                    prefixText: '€ ',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section: Préférences
            _buildSectionTitle('Préférences'),
            SwitchListTile(
              title: const Text('Vétérinaire préféré'),
              subtitle: const Text('Marquer comme vétérinaire préféré'),
              value: _isPreferred,
              onChanged: (value) {
                setState(() => _isPreferred = value);
              },
            ),
            ListTile(
              title: const Text('Note'),
              subtitle: Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() => _rating = index + 1);
                    },
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Section: Notes
            _buildSectionTitle('Notes'),
            _buildTextField(
              controller: _notesController,
              label: 'Notes additionnelles',
              hint: 'Informations complémentaires...',
              maxLines: 4,
            ),

            const SizedBox(height: 32),

            // Boutons d'action
            ElevatedButton(
              onPressed: _isLoading ? null : _saveVeterinarian,
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
                  : Text(isEdit ? 'Enregistrer' : 'Ajouter le vétérinaire'),
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

  Future<void> _saveVeterinarian() async {
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

    final provider = context.read<VeterinarianProvider>();
    final isEdit = widget.veterinarianId != null;

    final veterinarian = Veterinarian(
      id: isEdit
          ? widget.veterinarianId!
          : DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      title: _titleController.text.trim().isNotEmpty
          ? _titleController.text.trim()
          : null,
      licenseNumber: _licenseNumberController.text.trim(),
      specialties: _selectedSpecialties,
      clinic: _clinicController.text.trim().isNotEmpty
          ? _clinicController.text.trim()
          : null,
      phone: _phoneController.text.trim(),
      mobile: _mobileController.text.trim().isNotEmpty
          ? _mobileController.text.trim()
          : null,
      email: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : null,
      address: _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : null,
      city: _cityController.text.trim().isNotEmpty
          ? _cityController.text.trim()
          : null,
      postalCode: _postalCodeController.text.trim().isNotEmpty
          ? _postalCodeController.text.trim()
          : null,
      country: 'France',
      isAvailable: _isAvailable,
      emergencyService: _emergencyService,
      workingHours: _workingHoursController.text.trim().isNotEmpty
          ? _workingHoursController.text.trim()
          : null,
      consultationFee: _consultationFeeController.text.trim().isNotEmpty
          ? double.tryParse(_consultationFeeController.text.trim())
          : null,
      emergencyFee: _emergencyFeeController.text.trim().isNotEmpty
          ? double.tryParse(_emergencyFeeController.text.trim())
          : null,
      currency: 'EUR',
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      isPreferred: _isPreferred,
      rating: _rating,
      totalInterventions: isEdit
          ? provider
              .getVeterinarianById(widget.veterinarianId!)!
              .totalInterventions
          : 0,
      lastInterventionDate: isEdit
          ? provider
              .getVeterinarianById(widget.veterinarianId!)!
              .lastInterventionDate
          : null,
      createdAt: DateTime.now(),
      updatedAt: isEdit ? DateTime.now() : null,
    );

    if (isEdit) {
      provider.updateVeterinarian(veterinarian);
    } else {
      provider.addVeterinarian(veterinarian);
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
                ? 'Vétérinaire modifié avec succès'
                : 'Vétérinaire ajouté avec succès',
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
        title: const Text('Supprimer le vétérinaire'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer ce vétérinaire ? '
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
                  .read<VeterinarianProvider>()
                  .deleteVeterinarian(widget.veterinarianId!);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close edit screen
              Navigator.pop(context); // Close detail screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vétérinaire supprimé'),
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
