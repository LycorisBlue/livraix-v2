part of 'widget.withdrawal_sheet.dart';

class WithdrawalSheet extends StatefulWidget {
  final double currentBalance;
  final Function() onSuccess;

  const WithdrawalSheet({
    Key? key,
    required this.currentBalance,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<WithdrawalSheet> createState() => _WithdrawalSheetState();
}

class _WithdrawalSheetState extends State<WithdrawalSheet> {
  // Services
  final BalanceService _balanceService = BalanceService();

  // Controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // User Information
  UserDetails? _userDetails;

  // State Management
  bool _isLoading = true;
  bool _isProcessingWithdrawal = false;
  bool _hasCalculatedFees = false;
  String _selectedProvider = 'ORANGE';
  String? _amountError;
  String? _phoneError;
  String? _generalError;

  // Fee Information
  double _amount = 0;
  double _feeAmount = 0;
  double _totalAmount = 0;

  // Ajouter ces variables à la classe _WithdrawalSheetState
  Timer? _debounceTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();

    // Ajouter des listeners aux contrôleurs
    _phoneController.addListener(_detectProvider);
    _amountController.addListener(_handleAmountChange);
  }

  @override
  void dispose() {
    // Supprimer les listeners avant de détruire le widget
    _phoneController.removeListener(_detectProvider);
    _amountController.removeListener(_handleAmountChange);
    _amountController.dispose();
    _phoneController.dispose();
     _debounceTimer?.cancel();
    super.dispose();
  }

  /// Détecte le prestataire de service en fonction du numéro de téléphone
  void _detectProvider() {
    String phone = _phoneController.text.trim();

    if (phone.isEmpty || phone.length < 2) return;

    // Détection basée sur les premiers chiffres
    if (phone.startsWith('07')) {
      setState(() {
        _selectedProvider = 'Orange';
      });
    } else if (phone.startsWith('05')) {
      setState(() {
        _selectedProvider = 'MTN';
      });
    } else if (phone.startsWith('01')) {
      setState(() {
        _selectedProvider = 'Moov';
      });
    }

    // Vérifier si le numéro a 10 chiffres pour lancer le calcul des frais
    if (phone.length == 10 && _amountController.text.isNotEmpty) {
      _calculateFees();
    }
  }

  /// Gère les changements dans le champ de montant
void _handleAmountChange() {
    // Indiquer que l'utilisateur est en train de saisir
    _isTyping = true;

    // Annuler tout timer précédent
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    // Créer un nouveau timer pour débouncer le calcul
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      // Seulement si le numéro de téléphone est valide (10 chiffres)
      if (_phoneController.text.trim().length == 10 && _amountController.text.isNotEmpty) {
        _isTyping = false;
        _calculateFees();
      } else {
        setState(() {
          _hasCalculatedFees = false;
          _isTyping = false;
        });
      }
    });
  }

  /// Charge les détails de l'utilisateur depuis le stockage local
  Future<void> _loadUserDetails() async {
    try {
      final userDetails = await GeneralManagerDB.getUserDetails();
      setState(() {
        _userDetails = userDetails;

        // Initialiser le numéro de téléphone s'il est disponible
        if (userDetails != null && userDetails.profile.telephone.isNotEmpty) {
          _phoneController.text = userDetails.profile.telephone;
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _generalError = 'Erreur lors du chargement des informations utilisateur';
        _isLoading = false;
      });
    }
  }

  /// Calcule les frais en fonction du montant saisi
  /// Calcule les frais en fonction du montant saisi
  Future<void> _calculateFees() async {
    // Ne pas calculer si un calcul est déjà en cours
    if (_isLoading) return;

    // Valider que le montant est un nombre valide
    if (_amountController.text.isEmpty) {
      setState(() {
        _amountError = 'Veuillez saisir un montant';
        _hasCalculatedFees = false;
      });
      return;
    }

    // Valider que le numéro de téléphone est valide
    if (_phoneController.text.trim().length != 10) {
      setState(() {
        _phoneError = 'Le numéro doit avoir 10 chiffres';
        _hasCalculatedFees = false;
      });
      return;
    }

    try {
      final amount = double.parse(_amountController.text);

      if (amount <= 0) {
        setState(() {
          _amountError = 'Le montant doit être supérieur à 0';
          _hasCalculatedFees = false;
        });
        return;
      }

      if (amount < widget.currentBalance) { // Vérifier si le montant est inférieur au solde (modifier plss tard)
        setState(() {
          _amountError = 'Solde insuffisant';
          _hasCalculatedFees = false;
        });
        return;
      }

      setState(() {
        _amountError = null;
        _isLoading = true;
      });

      // Appeler le service pour calculer les frais
      final result = await _balanceService.calculateWithdrawalFee(
        country: 'CI',
        provider: _selectedProvider,
        amount: amount,
        operationType: 'TOP_UP',
        toReceive: true,
      );

      if (result['success']) {
        final data = result['data'];
        setState(() {
          _amount = amount;
          _feeAmount = data['feeAmount'] ?? 0.0;
          _totalAmount = data['totalAmount'] ?? 0.0;
          _hasCalculatedFees = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _generalError = result['message'] ?? 'Erreur lors du calcul des frais';
          _hasCalculatedFees = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _amountError = 'Montant invalide';
        _hasCalculatedFees = false;
        _isLoading = false;
      });
    }
  }

  /// Valide les champs avant de procéder au retrait
  bool _validateFields() {
    bool isValid = true;

    // Vérifier le montant
    if (_amountController.text.isEmpty) {
      setState(() {
        _amountError = 'Veuillez saisir un montant';
      });
      isValid = false;
    } else {
      try {
        final amount = double.parse(_amountController.text);
        if (amount <= 0) {
          setState(() {
            _amountError = 'Le montant doit être supérieur à 0';
          });
          isValid = false;
        } else if (amount < widget.currentBalance) { // Vérifier si le montant est inférieur au solde (modifier plss tard)
          setState(() {
            _amountError = 'Solde insuffisant';
          });
          isValid = false;
        } else {
          setState(() {
            _amountError = null;
          });
        }
      } catch (e) {
        setState(() {
          _amountError = 'Montant invalide';
        });
        isValid = false;
      }
    }

    // Vérifier le numéro de téléphone
    if (_phoneController.text.isEmpty) {
      setState(() {
        _phoneError = 'Veuillez saisir un numéro de téléphone';
      });
      isValid = false;
    } else if (_phoneController.text.length < 8) {
      setState(() {
        _phoneError = 'Numéro de téléphone invalide';
      });
      isValid = false;
    } else {
      setState(() {
        _phoneError = null;
      });
    }

    return isValid;
  }

  /// Effectue le retrait
  Future<void> _makeWithdrawal() async {
    if (!_validateFields()) {
      return;
    }

    if (!_hasCalculatedFees) {
      await _calculateFees();
      if (_generalError != null || _amountError != null) {
        return;
      }
    }

    setState(() {
      _isProcessingWithdrawal = true;
      _generalError = null;
    });

    try {
      final amount = double.parse(_amountController.text);

      final result = await _balanceService.makeWithdrawal(
        phoneNumber: _phoneController.text,
        amount: amount,
        provider: _selectedProvider,
        country: 'CI',
        currency: 'XOF',
      );

      setState(() {
        _isProcessingWithdrawal = false;
      });

      if (result['success']) {
        // Fermer le bottomsheet et notifier le parent du succès
        if (mounted) {
          Navigator.of(context).pop();
          widget.onSuccess();

          // Montrer une notification de succès
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Retrait effectué avec succès!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _generalError = result['message'] ?? 'Erreur lors du retrait';
        });
      }
    } catch (e) {
      setState(() {
        _isProcessingWithdrawal = false;
        _generalError = 'Une erreur est survenue: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête du bottomsheet
            const Center(
              child: SheetHeader(
                title: 'Retrait de fonds',
                subtitle: 'Saisissez les informations pour effectuer un retrait',
              ),
            ),
            const SizedBox(height: 24),

            // Informations sur l'utilisateur et son solde
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_userDetails != null)
              UserBalanceInfo(
                userName: '${_userDetails!.profile.prenom} ${_userDetails!.profile.nom}',
                balance: widget.currentBalance,
              ),

            const SizedBox(height: 24),

            // Champ de montant
            AmountField(
              controller: _amountController,
              label: 'Montant à retirer',
              errorText: _amountError,
              onChanged: (value) {
                // Réinitialiser les calculs de frais lorsque le montant change
                setState(() {
                  _hasCalculatedFees = false;
                });
              },
            ),
            const SizedBox(height: 16),

            // Sélection du prestataire de service
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.payment,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Prestataire: $_selectedProvider',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Numéro de téléphone
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Numéro de téléphone',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Ex: 0701234567',
                    prefixText: '+225 ',
                    errorText: _phoneError,
                    helperText: 'Orange: 07, MTN: 05, Moov: 01',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bouton pour calculer les frais
            if (_isLoading && !_isProcessingWithdrawal)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            // Détails des frais (visible seulement après calcul)
            if (_hasCalculatedFees) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Détails du retrait',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    FeeDetailItem(
                      label: 'Montant du retrait',
                      value: '${_amount.toStringAsFixed(0)} XOF',
                    ),
                    FeeDetailItem(
                      label: 'Frais de service',
                      value: '${_feeAmount.toStringAsFixed(0)} XOF',
                    ),
                    const Divider(),
                    FeeDetailItem(
                      label: 'Montant total',
                      value: '${_totalAmount.toStringAsFixed(0)} XOF',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ],

            // Message d'erreur général
            if (_generalError != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _generalError!,
                        style: TextStyle(color: Colors.red[700], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessingWithdrawal ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                        onPressed: (_isLoading ||
                            _isProcessingWithdrawal ||
                            !_hasCalculatedFees ||
                            _phoneController.text.trim().length != 10 ||
                            _isTyping)
                        ? null
                        : _makeWithdrawal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isProcessingWithdrawal
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Effectuer le retrait'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
