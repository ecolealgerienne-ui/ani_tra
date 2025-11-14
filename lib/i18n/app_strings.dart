// lib/i18n/app_strings.dart

/// Clés de traduction pour les chaînes de caractères
/// Utilisé avec AppLocalizations.of(context).translate(AppStrings.xxx)
class AppStrings {
  // FARM MANAGEMENT (7 clés)
  static const String userName = 'userName';
  static const String farmManagement = 'farmManagement';
  static const String currentFarm = 'currentFarm';
  static const String farmName = 'farmName';
  static const String switchFarm = 'switchFarm';
  static const String availableFarms = 'availableFarms';
  static const String farmPhase4Note = 'farmPhase4Note';

  // ============ GENERAL ====================
  static const String ok = 'ok';
  static const String cancel = 'cancel';
  static const String delete = 'delete';
  static const String rename = 'rename';
  static const String duplicate = 'duplicate';
  static const String keep = 'keep';
  static const String date = 'date';
  static const String error = 'error';
  static const String search = 'search';
  static const String optional = 'optional';
  static const String save = 'save';
  static const String nothingSelected = 'nothingSelected';

  // ============ SYNC SCREEN ============
  static const String sync = 'sync';
  static const String offlineMode = 'offlineMode';
  static const String pendingData = 'pendingData';
  static const String syncSuccess = 'syncSuccess';
  static const String syncNow = 'syncNow';

  // ============ WEIGHT RECORD SCREEN ============
  static const String newWeight = 'newWeight';
  static const String scanAnimal = 'scanAnimal';
  static const String weight = 'weight';
  static const String noAnimalsAvailable = 'noAnimalsAvailable';
  static const String noAnimalsAvailableForWeight =
      'noAnimalsAvailableForWeight';
  static const String weightRecorded = 'weightRecorded';
  static const String selectDate = 'selectDate';
  static const String selectAnimal = 'selectAnimal';
  static const String weightSource = 'weightSource';
  static const String weightSourceScale = 'weightSourceScale';
  static const String weightSourceManual = 'weightSourceManual';
  static const String weightSourceEstimated = 'weightSourceEstimated';
  static const String weightSourceVeterinary = 'weightSourceVeterinary';
  static const String notes = 'notes';

  // ============ SETTINGS SCREEN ============
  static const String deleteCache = 'deleteCache';
  static const String settings = 'settings';
  static const String account = 'account';
  static const String userProfile = 'userProfile';
  static const String changePassword = 'changePassword';
  static const String changeVeterinarian = 'changeVeterinarian';
  static const String farmPreferences = 'farmPreferences';
  static const String defaultVeterinarian = 'defaultVeterinarian';
  static const String noVeterinarianDefined = 'noVeterinarianDefined';
  static const String scanQr = 'scanQr';
  static const String appearance = 'appearance';
  static const String language = 'language';
  static const String darkMode = 'darkMode';
  static const String notifications = 'notifications';
  static const String treatmentReminders = 'treatmentReminders';
  static const String withdrawalAlerts = 'withdrawalAlerts';
  static const String campaignNotifications = 'campaignNotifications';
  static const String sound = 'sound';
  static const String vibration = 'vibration';
  static const String security = 'security';
  static const String biometric = 'biometric';
  static const String autoLock = 'autoLock';
  static const String storage = 'storage';
  static const String cache = 'cache';
  static const String autoBackup = 'autoBackup';
  static const String help = 'help';
  static const String about = 'about';
  static const String contactSupport = 'contactSupport';
  static const String hours = 'hours';
  static const String sendEmail = 'sendEmail';
  static const String resetPreferences = 'resetPreferences';
  static const String veterinarianPrescriber = 'veterinarianPrescriber';
  static const String receiveAllNotifications = 'receiveAllNotifications';
  static const String waitingPeriodsDeadlines = 'waitingPeriodsDeadlines';
  static const String animalsWithActiveWaitingPeriod =
      'animalsWithActiveWaitingPeriod';
  static const String newCampaignsReminders = 'newCampaignsReminders';
  static const String enableDarkTheme = 'enableDarkTheme';
  static const String restartAppToApplyTheme = 'restartAppToApplyTheme';
  static const String textSize = 'textSize';
  static const String themeColor = 'themeColor';
  static const String biometricAuthentication = 'biometricAuthentication';
  static const String useFingerprintFaceId = 'useFingerprintFaceId';
  static const String biometryEnabled = 'biometryEnabled';
  static const String biometryDisabled = 'biometryDisabled';
  static const String afterMinutesInactivity = 'afterMinutesInactivity';
  static const String lockDelay = 'lockDelay';
  static const String minute = 'minute';
  static const String minutes = 'minutes';
  static const String activeSessions = 'activeSessions';
  static const String manageConnectedDevices = 'manageConnectedDevices';
  static const String synchronization = 'synchronization';
  static const String onlineMode = 'onlineMode';
  static const String serverConnectionActive = 'serverConnectionActive';
  static const String localDataOnly = 'localDataOnly';
  static const String autoSync = 'autoSync';
  static const String syncEvery15Minutes = 'syncEvery15Minutes';
  static const String viewSyncDetails = 'viewSyncDetails';
  static const String historyConflicts = 'historyConflicts';
  static const String storageData = 'storageData';
  static const String usedStorage = 'usedStorage';
  static const String calculating = 'calculating';
  static const String clearCache = 'clearCache';
  static const String freeSpace = 'freeSpace';
  static const String dailyDataBackup = 'dailyDataBackup';
  static const String exportData = 'exportData';
  static const String importData = 'importData';
  static const String fromCsvExcel = 'fromCsvExcel';
  static const String clearLocalData = 'clearLocalData';
  static const String deleteAllUnsyncedData = 'deleteAllUnsyncedData';
  static const String version = 'version';
  static const String openSourceLicenses = 'openSourceLicenses';
  static const String privacyPolicy = 'privacyPolicy';
  static const String termsOfService = 'termsOfService';
  static const String helpSupport = 'helpSupport';
  static const String debug = 'debug';
  static const String simulateSyncError = 'simulateSyncError';
  static const String offlineModeActivated = 'offlineModeActivated';
  static const String remove = 'remove';
  static const String notSpecified = 'notSpecified';
  static const String searchVeterinarian = 'searchVeterinarian';
  static const String currentDevice = 'currentDevice';
  static const String csvExcelXml = 'csvExcelXml';
  static const String fromCsvOrExcel = 'fromCsvOrExcel';
  static const String rfidTroupeau = 'rfidTroupeau';
  static const String sheepManagementSystem = 'sheepManagementSystem';

  // ============ TREATMENT SCREEN ============
  static const String treatment = 'treatment';
  static const String addTreatment = 'addTreatment';
  static const String selectProduct = 'selectProduct';
  static const String dose = 'dose';
  static const String veterinarian = 'veterinarian';
  static const String added = 'added';

  // ============ VACCINATION SCREEN ============
  static const String vaccinationDetail = 'vaccinationDetail';
  static const String information = 'information';
  static const String animal = 'animal';
  static const String reminder = 'reminder';
  static const String protocol = 'protocol';
  static const String confirm = 'confirm';

  // ============ EID HISTORY & CHANGE ============
  static const String noEidChanges = 'noEidChanges';
  static const String eidHistory = 'eidHistory';
  static const String oldEid = 'oldEid';
  static const String newEid = 'newEid';
  static const String changeEidTitle = 'changeEidTitle';
  static const String currentEid = 'currentEid';
  static const String newEidLabel = 'newEidLabel';
  static const String changeReason = 'changeReason';
  static const String optionalNotes = 'optionalNotes';
  static const String eidChangedSuccess = 'eidChangedSuccess';
  static const String eidChangedError = 'eidChangedError';
  static const String eidRequired = 'eidRequired';
  static const String eidMustBeDifferent = 'eidMustBeDifferent';
  static const String eidTooShort = 'eidTooShort';
  static const String chipLost = 'chipLost';
  static const String chipBroken = 'chipBroken';
  static const String chipDefective = 'chipDefective';
  static const String entryError = 'entryError';
  static const String replacement = 'replacement';
  static const String otherReason = 'otherReason';

  // ============ FARM PREFERENCES ============
  static const String farmPreferencesTitle = 'farmPreferencesTitle';
  static const String farmPreferencesSubtitle = 'farmPreferencesSubtitle';
  static const String defaultAnimalType = 'defaultAnimalType';
  static const String defaultBreed = 'defaultBreed';
  static const String noBreedSelected = 'noBreedSelected';
  static const String farmPreferencesInfo = 'farmPreferencesInfo';
  static const String noBreedAvailable = 'noBreedAvailable';
  static const String noneChooseEachTime = 'noneChooseEachTime';

  // ============ FARM SETTINGS SCREEN ============
  static const String farmSettings = 'farmSettings';
  static const String farmSettingsTitle = 'farmSettingsTitle';
  static const String farmSettingsSubtitle = 'farmSettingsSubtitle';
  static const String farmSelection = 'farmSelection';
  static const String farmSelectionSubtitle = 'farmSelectionSubtitle';
  static const String selectFarm = 'selectFarm';
  static const String breedingPreferences = 'breedingPreferences';
  static const String breedingPreferencesSubtitle = 'breedingPreferencesSubtitle';
  static const String defaultSpecies = 'defaultSpecies';
  static const String selectDefaultSpecies = 'selectDefaultSpecies';
  static const String selectDefaultBreed = 'selectDefaultBreed';
  static const String veterinarianSettings = 'veterinarianSettings';
  static const String veterinarianSettingsSubtitle = 'veterinarianSettingsSubtitle';
  static const String alertSettings = 'alertSettings';
  static const String alertSettingsSubtitle = 'alertSettingsSubtitle';
  static const String manageAlertPreferences = 'manageAlertPreferences';
  static const String preferencesUpdated = 'preferencesUpdated';
  static const String errorUpdatingPreferences = 'errorUpdatingPreferences';
  static const String noFarmSelected = 'noFarmSelected';
  static const String pleaseSelectFarm = 'pleaseSelectFarm';

  // ============ ALERTS (24) ============
  static const String alerts = 'alerts';
  static const String noAlertsTitle = 'noAlertsTitle';
  static const String noAlertsSubtitle = 'noAlertsSubtitle';
  static const String alertsRecalculated = 'alertsRecalculated';
  static const String recalculateAlerts = 'recalculateAlerts';
  static const String debugInfo = 'debugInfo';
  static const String urgentAlertsCount = 'urgentAlertsCount';
  static const String importantAlertsCount = 'importantAlertsCount';
  static const String routineAlertsCount = 'routineAlertsCount';
  static const String totalCount = 'totalCount';
  static const String urgentAlerts = 'urgentAlerts';
  static const String importantAlerts = 'importantAlerts';
  static const String routineAlerts = 'routineAlerts';
  static const String overview = 'overview';
  static const String urgentLabel = 'urgentLabel';
  static const String importantLabel = 'importantLabel';
  static const String routineLabel = 'routineLabel';
  static const String animalNotFound = 'animalNotFound';
  static const String animalsToWeigh = 'animalsToWeigh';
  static const String incompleteEvent = 'incompleteEvent';
  static const String complete = 'complete';
  static const String batchAnimals = 'batchAnimals';
  static const String animalNotFoundAlert = 'animalNotFoundAlert';

  // ========== ALERTS - MESSAGES (21 nouvelles clés) ==========
  static const String withdrawalDeadlineExceeded = 'withdrawalDeadlineExceeded';
  static const String withdrawalInProgress = 'withdrawalInProgress';
  static const String seeAnimal = 'seeAnimal';
  static const String eidMissing = 'eidMissing';
  static const String mandatoryIdentification = 'mandatoryIdentification';
  static const String addEid = 'addEid';
  static const String eventToFinalize = 'eventToFinalize';
  static const String criticalSync = 'criticalSync';
  static const String syncRequired = 'syncRequired';
  static const String synchronize = 'synchronize';
  static const String recommendedWeighing = 'recommendedWeighing';
  static const String seeAnimals = 'seeAnimals';
  static const String treatmentToRenew = 'treatmentToRenew';
  static const String renew = 'renew';
  static const String lotToFinalize = 'lotToFinalize';
  static const String finalize = 'finalize';
  static const String motherNotDeclared = 'motherNotDeclared';
  static const String declareMother = 'declareMother';
  static const String invalidMother = 'invalidMother';
  static const String correct = 'correct';
  static const String noAlert = 'noAlert';

  // ========== ALERT CATEGORIES (20 nouvelles clés) ==========
  static const String categoryWithdrawal = 'categoryWithdrawal';
  static const String categoryIdentification = 'categoryIdentification';
  static const String categoryRegistry = 'categoryRegistry';
  static const String categorySynchronization = 'categorySynchronization';
  static const String categoryWeighing = 'categoryWeighing';
  static const String categoryTreatment = 'categoryTreatment';
  static const String categoryBatch = 'categoryBatch';
  static const String categoryBirth = 'categoryBirth';
  static const String categoryMortality = 'categoryMortality';
  static const String categoryOther = 'categoryOther';
  static const String delayBeforeSlaughter = 'delayBeforeSlaughter';
  static const String eidAndTraceability = 'eidAndTraceability';
  static const String registryUpdate = 'registryUpdate';
  static const String dataSave = 'dataSave';
  static const String weightTracking = 'weightTracking';
  static const String veterinaryCare = 'veterinaryCare';
  static const String batchManagement = 'batchManagement';
  static const String birthDeclaration = 'birthDeclaration';
  static const String mortalityManagement = 'mortalityManagement';
  static const String otherAlerts = 'otherAlerts';

  // ============ ANIMAL SCREENS (27) ============
  static const String animals = 'animals';
  static const String addAnimal = 'addAnimal';
  static const String animalDetail = 'animalDetail';
  static const String searchHint = 'searchHint';
  static const String noAnimals = 'noAnimals';
  static const String filter = 'filter';
  static const String eid = 'eid';
  static const String eidCurrent = 'eidCurrent';
  static const String eidMother = 'eidMother';
  static const String officialNumber = 'officialNumber';
  static const String visualId = 'visualId';
  static const String mother = 'mother';
  static const String motherOptional = 'motherOptional';
  static const String motherUnknown = 'motherUnknown';
  static const String birthDate = 'birthDate';
  static const String birthDateRequired = 'birthDateRequired';
  static const String sex = 'sex';
  static const String sexRequired = 'sexRequired';
  static const String male = 'male';
  static const String female = 'female';
  static const String breed = 'breed';
  static const String breedOptional = 'breedOptional';
  static const String status = 'status';
  static const String observations = 'observations';

  // ========== ANIMAL VALIDATION (9 nouvelles clés) ==========
  static const String animalNotFemale = 'animalNotFemale';
  static const String animalNotAlive = 'animalNotAlive';
  static const String animalTooYoung = 'animalTooYoung';
  static const String noId = 'noId';
  static const String noIdentification = 'noIdentification';
  static const String idPrefix = 'idPrefix';
  static const String eidPrefix = 'eidPrefix';
  static const String numberPrefix = 'numberPrefix';
  static const String notAvailable = 'notAvailable';

  // ============ WEIGHT HISTORY SCREEN (15) ============
  static const String weightHistory = 'weightHistory';
  static const String noWeights = 'noWeights';
  static const String noWeightsMessage = 'noWeightsMessage';
  static const String addWeight = 'addWeight';
  static const String noNumber = 'noNumber';
  static const String statistics = 'statistics';
  static const String lastWeight = 'lastWeight';
  static const String weightCount = 'weightCount';
  static const String averageWeight = 'averageWeight';
  static const String totalGain = 'totalGain';
  static const String gmq = 'gmq';
  static const String weightEvolution = 'weightEvolution';
  static const String evolutionOverWeights = 'evolutionOverWeights';
  static const String completeHistory = 'completeHistory';
  static const String current = 'current';

  // ============ MOTHER HISTORY SCREEN (17) ============
  static const String reproductionHistory = 'reproductionHistory';
  static const String descendants = 'descendants';
  static const String noDescendants = 'noDescendants';
  static const String age = 'age';
  static const String reproductionStats = 'reproductionStats';
  static const String totalBirths = 'totalBirths';
  static const String aliveFemales = 'aliveFemales';
  static const String survivalRate = 'survivalRate';
  static const String avgInterval = 'avgInterval';
  static const String lastBirth = 'lastBirth';
  static const String bornOn = 'bornOn';
  static const String months = 'months';
  static const String alive = 'alive';
  static const String sold = 'sold';
  static const String dead = 'dead';
  static const String slaughtered = 'slaughtered';

  // ============ SCANNER SCREEN (5) ============
  static const String scanner = 'scanner';
  static const String scannedTheAnimals = 'scannedTheAnimals';
  static const String scanHint = 'scanHint';
  static const String scanError = 'scanError';
  static const String processing = 'processing';
  static const String manualEntry = 'manualEntry';

  // ============ HOME SCREEN ============
  static const String dashboard = 'dashboard';

  // ============ BATCH SCREENS ============
  static const String batches = 'batches';
  static const String noBatches = 'noBatches';
  static const String prepareBatch = 'prepareBatch';
  static const String batchDescription = 'batchDescription';
  static const String batchName = 'batchName';
  static const String batchNameHint = 'batchNameHint';
  static const String batchPurpose = 'batchPurpose';
  static const String batchNameRequired = 'batchNameRequired';
  static const String minCharacters = 'minCharacters';
  static const String sale = 'sale';
  static const String slaughter = 'slaughter';
  static const String treatmentBatch = 'treatmentBatch';
  static const String other = 'other';
  static const String startScan = 'startScan';
  static const String noAnimalsAvailableBatch = 'noAnimalsAvailableBatch';
  static const String animalDuplicate = 'animalDuplicate';
  static const String animalRemoved = 'animalRemoved';
  static const String batchEmpty = 'batchEmpty';
  static const String scannedAnimals = 'scannedAnimals';
  static const String newBatch = 'newBatch';
  static const String noBatchesCreated = 'noBatchesCreated';
  static const String deleteBatchTitle = 'deleteBatchTitle';
  static const String deleteBatchMessage = 'deleteBatchMessage';
  static const String batchDeleted = 'batchDeleted';
  static const String saleOfBatch = 'saleOfBatch';
  static const String slaughterOfBatch = 'slaughterOfBatch';
  static const String toImplement = 'toImplement';
  static const String featureComingSoon = 'featureComingSoon';
  static const String export = 'export';
  static const String exportComingSoon = 'exportComingSoon';
  static const String completedOn = 'completedOn';
  static const String useForSale = 'useForSale';
  static const String useForSlaughter = 'useForSlaughter';
  static const String applyTreatment = 'applyTreatment';
  static const String use = 'use';
  static const String animalAdded = 'animalAdded';
  static const String batchSaved = 'batchSaved';
  static const String cancelBatchTitle = 'cancelBatchTitle';
  static const String cancelBatchMessage = 'cancelBatchMessage';
  static const String cancelBatchEmpty = 'cancelBatchEmpty';
  static const String no = 'no';
  static const String yes = 'yes';
  static const String yesCancel = 'yesCancel';
  static const String noAnimalScanned = 'noAnimalScanned';
  static const String animalsScannedCount = 'animalsScannedCount';
  static const String scanOneAnimal = 'scanOneAnimal';
  static const String scanAnimalsOneByOne = 'scanAnimalsOneByOne';

  // ============ LOT SCREENS ============
  static const String lots = 'lots';
  static const String noLots = 'noLots';
  static const String lotDetail = 'lotDetail';
  static const String finalizeLot = 'finalizeLot';
  static const String chooseLotType = 'chooseLotType';
  static const String treatmentLot = 'treatmentLot';
  static const String saleLot = 'saleLot';
  static const String slaughterLot = 'slaughterLot';
  static const String createLot = 'createLot';
  static const String lotName = 'lotName';
  static const String duplicateLot = 'duplicateLot';
  static const String newLotName = 'newLotName';
  static const String keepAnimals = 'keepAnimals';
  static const String keepType = 'keepType';
  static const String deleteLot = 'deleteLot';
  static const String myLots = 'myLots';
  static const String openLots = 'openLots';
  static const String closedLots = 'closedLots';
  static const String noOpenLot = 'noOpenLot';
  static const String noClosedLot = 'noClosedLot';
  static const String invalidPrice = 'invalidPrice';
  static const String lotNotFound = 'lotNotFound';
  static const String groupedHealthTreatment = 'groupedHealthTreatment';
  static const String slaughterPrep = 'slaughterPrep';
  static const String animalSale = 'animalSale';
  static const String treatmentWillApply = 'treatmentWillApply';
  static const String buyerName = 'buyerName';
  static const String farmNumber = 'farmNumber';
  static const String pricePerAnimal = 'pricePerAnimal';
  static const String fieldRequired = 'fieldRequired';
  static const String deleteLotConfirm = 'deleteLotConfirm';
  static const String vetValidated = 'vetValidated';
  static const String ewesMonthHint = 'ewesMonthHint';
  static const String addCopieToName = 'addCopieToName';
  static const String noVeterinarianFound = 'noVeterinarianFound';
  static const String product = 'product';
  static const String treatmentDate = 'treatmentDate';
  static const String buyer = 'buyer';
  static const String totalPrice = 'totalPrice';
  static const String slaughterhouse = 'slaughterhouse';
  static const String males = 'males';
  static const String females = 'females';
  static const String close = 'close';
  static const String newName = 'newName';
  static const String lotRenamed = 'lotRenamed';
  static const String lotDuplicated = 'lotDuplicated';
  static const String lotClosed = 'lotClosed';
  static const String lotOpened = 'lotOpened';
  static const String onThe = 'onThe';
  static const String type = 'type';
  static const String animalRemovedFromLot = 'animalRemovedFromLot';
  static const String animalsAdded = 'animalsAdded';
  static const String scanAnimals = 'scanAnimals';
  static const String lotFinalized = 'lotFinalized';
  static const String saleAnimals = 'saleAnimals';
  static const String slaughterPreparation = 'slaughterPreparation';
  static const String treatmentWillApplyToAnimals =
      'treatmentWillApplyToAnimals';
  static const String typeNotDefined = 'typeNotDefined';
  static const String allGoodWithHerd = 'allGoodWithHerd';
  static const String animalNotFoundSearch = 'animalNotFoundSearch';
  static const String quickActions = 'quickActions';
  static const String manageHerd = 'manageHerd';
  static const String campaignsGroups = 'campaignsGroups';
  static const String exportRegistry = 'exportRegistry';
  static const String pdfControl = 'pdfControl';
  static const String identifyAnimal = 'identifyAnimal';
  static const String aliveStatus = 'aliveStatus';
  static const String activeStatus = 'activeStatus';
  static const String urgentStatus = 'urgentStatus';

  // ==================== LOT STATUS ====================
  static const String lotStatusOpen = 'lotStatusOpen';
  static const String lotStatusClosed = 'lotStatusClosed';
  static const String lotStatusArchived = 'lotStatusArchived';
  static const String archiveLot = 'archiveLot';
  static const String archiveConfirm = 'archiveConfirm';
  static const String archiveConfirmMessage = 'archiveConfirmMessage';
  static const String lotArchived = 'lotArchived';

  // ============ MEDICAL & EVENTS (24) ============
  static const String recordSale = 'recordSale';
  static const String confirmSale = 'confirmSale';
  static const String saleRecorded = 'saleRecorded';
  static const String recordDeath = 'recordDeath';
  static const String confirmDeath = 'confirmDeath';
  static const String deathRecorded = 'deathRecorded';
  static const String irreversibleWarning = 'irreversibleWarning';
  static const String deathCause = 'deathCause';
  static const String buyerIdOptional = 'buyerIdOptional';
  static const String priceEur = 'priceEur';
  static const String step1ScanAnimal = 'step1ScanAnimal';
  static const String step2BuyerInfo = 'step2BuyerInfo';
  static const String step3SalePrice = 'step3SalePrice';
  static const String withdrawalPeriodActive = 'withdrawalPeriodActive';
  static const String pleaseEnterBuyerName = 'pleaseEnterBuyerName';
  static const String scanVeterinarian = 'scanVeterinarian';
  static const String noVeterinarianSelected = 'noVeterinarianSelected';
  static const String scanQrCode = 'scanQrCode';
  static const String exportDocuments = 'exportDocuments';
  static const String pdfDownloaded = 'pdfDownloaded';

  // Ajouter suite à des erreurs d'ajout de clés
  static const String notesOptional = 'notesOptional';

  // Ajouter dans la section MEDICAL & EVENTS
  static const String causeNotSpecified = 'causeNotSpecified';
  static const String deathCauseHint = 'deathCauseHint';
  static const String buyerNameHint = 'buyerNameHint';
  static const String buyerIdHint = 'buyerIdHint';
  static const String priceHint = 'priceHint';

  // Ajouter dans une nouvelle section MEDICAL ACT SCREEN
  static const String actType = 'actType';
  static const String standardCure = 'standardCure';
  static const String days = 'days';
  static const String administration = 'administration';
  static const String single = 'single';
  static const String dosage = 'dosage';
  static const String calculatedAccording = 'calculatedAccording';
  static const String formula = 'formula';
  static const String weightNotAvailable = 'weightNotAvailable';
  static const String enterDosage = 'enterDosage';
  static const String addWeightToCalculate = 'addWeightToCalculate';
  static const String productDosage = 'productDosage';
  static const String indicativeCalculation = 'indicativeCalculation';
  static const String doseIndividually = 'doseIndividually';
  static const String route = 'route';
  static const String oral = 'oral';
  static const String topical = 'topical';
  static const String site = 'site';
  static const String neck = 'neck';
  static const String thigh = 'thigh';
  static const String flank = 'flank';
  static const String hindQuarter = 'hindQuarter';
  static const String jugularVein = 'jugularVein';
  static const String reminders = 'reminders';
  static const String sendMeReminders = 'sendMeReminders';
  static const String reminderTime = 'reminderTime';
  static const String configureReminders = 'configureReminders';
  static const String to = 'to';
  static const String configureCustomReminders = 'configureCustomReminders';
  static const String reminderS = 'reminderS';
  static const String configureVaccinationReminders =
      'configureVaccinationReminders';
  static const String withdrawalPeriods = 'withdrawalPeriods';
  static const String meat = 'meat';
  static const String milk = 'milk';
  static const String additionalNotesOptional = 'additionalNotesOptional';
  static const String prescribingVeterinarian = 'prescribingVeterinarian';
  static const String validated = 'validated';
  static const String pleaseSelectProduct = 'pleaseSelectProduct';
  static const String pleaseEnterValidDosage = 'pleaseEnterValidDosage';
  static const String treatmentRecordedSuccess = 'treatmentRecordedSuccess';
  static const String vaccinationRecordedSuccess = 'vaccinationRecordedSuccess';
  static const String treat = 'treat';
  static const String treatBatch = 'treatBatch';
  static const String vaccination = 'vaccination';
  static const String batch = 'batch';
  static const String species = 'species';

  // Ajouter dans la section EXPORT & PDF
  static const String myFarm = 'myFarm';
  static const String animalInventory = 'animalInventory';
  static const String total = 'total';
  static const String animalsCount = 'animalsCount';
  static const String eidLabel = 'eidLabel';
  static const String maleShort = 'maleShort';
  static const String femaleShort = 'femaleShort';
  static const String cannotAccessDownloads = 'cannotAccessDownloads';
  static const String completeRegistry = 'completeRegistry';
  static const String herdInventory = 'herdInventory';
  static const String completeHerdList = 'completeHerdList';

  // Ajouter dans la section SYNC SCREEN (compléter la section existante)
  static const String onlineModeActivated = 'onlineModeActivated';
  static const String toggleOnlineOffline = 'toggleOnlineOffline';
  static const String connectedToServer = 'connectedToServer';
  static const String syncAvailable = 'syncAvailable';
  static const String dataWillSyncLater = 'dataWillSyncLater';
  static const String lastSync = 'lastSync';
  static const String never = 'never';
  static const String syncFailed = 'syncFailed';
  static const String syncInProgress = 'syncInProgress';
  static const String requiresConnection = 'requiresConnection';
  static const String allDataSynchronized = 'allDataSynchronized';
  static const String syncError = 'syncError';
  static const String localDataSummary = 'localDataSummary';
  static const String treatments = 'treatments';
  static const String campaigns = 'campaigns';
  static const String justNow = 'justNow';
  static const String minutesAgo = 'minutesAgo';
  static const String hoursAgo = 'hoursAgo';

  // Ajouter dans la section OLD TREATMENT SCREEN
  static const String treatmentDash = 'treatmentDash';
  static const String addCare = 'addCare';
  static const String treatmentForAnimals = 'treatmentForAnimals';
  static const String careAdded = 'careAdded';
  static const String individualTreatment = 'individualTreatment';
  static const String groupTreatment = 'groupTreatment';
  static const String oneAnimalConcerned = 'oneAnimalConcerned';
  static const String animalsConcerned = 'animalsConcerned';
  static const String medicalProduct = 'medicalProduct';
  static const String withdrawalDelay = 'withdrawalDelay';
  static const String meatDays = 'meatDays';
  static const String doseExample = 'doseExample';
  static const String unitMl = 'unitMl';
  static const String pleaseEnterDose = 'pleaseEnterDose';
  static const String invalidDose = 'invalidDose';
  static const String treatmentDateLabel = 'treatmentDateLabel';
  static const String notesHintTreatment = 'notesHintTreatment';

  // Ajouter dans la section VACCINATION DETAIL SCREEN
  static const String animalsLowercase = 'animalsLowercase';
  static const String vaccinationDate = 'vaccinationDate';
  static const String doseLabel = 'doseLabel';
  static const String administrationRoute = 'administrationRoute';
  static const String lotNumber = 'lotNumber';
  static const String expirationDate = 'expirationDate';
  static const String veterinarianLabel = 'veterinarianLabel';
  static const String withdrawalPeriodLabel = 'withdrawalPeriodLabel';
  static const String daysRemaining = 'daysRemaining';
  static const String groupVaccination = 'groupVaccination';
  static const String animalPrefix = 'animalPrefix';
  static const String unknownAnimal = 'unknownAnimal';
  static const String lateByDays = 'lateByDays';
  static const String today = 'today';
  static const String inDays = 'inDays';
  static const String nextReminder = 'nextReminder';
  static const String notesLabel = 'notesLabel';
  static const String protocolLabel = 'protocolLabel';
  static const String name = 'name';
  static const String description = 'description';
  static const String reminderFrequency = 'reminderFrequency';
  static const String recommendedPeriod = 'recommendedPeriod';
  static const String protocolNotes = 'protocolNotes';
  static const String deleteVaccination = 'deleteVaccination';
  static const String deleteVaccinationConfirm = 'deleteVaccinationConfirm';
  static const String vaccinationDeleted = 'vaccinationDeleted';

  // Ajouter dans la section WEIGHT RECORD SCREEN
  static const String animalScanned = 'animalScanned';
  static const String stepOneAnimal = 'stepOneAnimal';
  static const String stepTwoWeight = 'stepTwoWeight';
  static const String stepThreeSource = 'stepThreeSource';
  static const String stepFourDate = 'stepFourDate';
  static const String stepFiveNotes = 'stepFiveNotes';
  static const String weightRequired = 'weightRequired';
  static const String invalidWeight = 'invalidWeight';
  static const String weightRangeError = 'weightRangeError';
  static const String measurementSource = 'measurementSource';
  static const String reliability = 'reliability';
  static const String weightHintExample = 'weightHintExample';
  static const String unitKg = 'unitKg';
  static const String notesHintWeight = 'notesHintWeight';

  // Ajouter dans la section EID CHANGE & HISTORY
  static const String newEidHint = 'newEidHint';
  static const String notesHintEid = 'notesHintEid';

  // Ajouter dans la section FARM MANAGEMENT & PREFERENCES
  static const String notDefined = 'notDefined';
  static const String farmEmojiSheep = 'farmEmojiSheep';

  // ========== SETTINGS SCREEN ==========
  static const String adminEmail = 'adminEmail';
  static const String languageSection = 'languageSection';
  static const String french = 'french';
  static const String arabic = 'arabic';
  static const String english = 'english';
  static const String colorBlue = 'colorBlue';
  static const String colorGreen = 'colorGreen';
  static const String colorPurple = 'colorPurple';
  static const String colorOrange = 'colorOrange';
  static const String appVersion = 'appVersion';
  static const String mvpOnly = 'mvpOnly';
  static const String openSyncScreen = 'openSyncScreen';
  static const String fullName = 'fullName';
  static const String profileEditComingSoon = 'profileEditComingSoon';
  static const String modify = 'modify';
  static const String currentPassword = 'currentPassword';
  static const String newPassword = 'newPassword';
  static const String confirmPassword = 'confirmPassword';
  static const String passwordChangedSuccess = 'passwordChangedSuccess';
  static const String chooseColor = 'chooseColor';
  static const String restartAppForColor = 'restartAppForColor';
  static const String oneMinute = 'oneMinute';
  static const String fiveMinutes = 'fiveMinutes';
  static const String fifteenMinutes = 'fifteenMinutes';
  static const String thirtyMinutes = 'thirtyMinutes';
  static const String thisDevice = 'thisDevice';
  static const String activeNow = 'activeNow';
  static const String tabletSamsung = 'tabletSamsung';
  static const String twoHoursAgo = 'twoHoursAgo';
  static const String sessionDisconnected = 'sessionDisconnected';
  static const String clearCacheDescription = 'clearCacheDescription';
  static const String cacheCleared = 'cacheCleared';
  static const String clear = 'clear';
  static const String csvFile = 'csvFile';
  static const String importFromCsv = 'importFromCsv';
  static const String importCsvComingSoon = 'importCsvComingSoon';
  static const String excelFile = 'excelFile';
  static const String importFromExcel = 'importFromExcel';
  static const String importExcelComingSoon = 'importExcelComingSoon';
  static const String exportCsvComingSoon = 'exportCsvComingSoon';
  static const String exportXmlComingSoon = 'exportXmlComingSoon';
  static const String exportExcelComingSoon = 'exportExcelComingSoon';
  static const String clearDataConfirmTitle = 'clearDataConfirmTitle';
  static const String clearDataConfirmMessage = 'clearDataConfirmMessage';
  static const String featureDisabledMvp = 'featureDisabledMvp';
  static const String veterinarianSetDefault = 'veterinarianSetDefault';
  static const String veterinarianValidated = 'veterinarianValidated';
  static const String selectDefaultVeterinarian = 'selectDefaultVeterinarian';
  static const String privacyPolicyContent = 'privacyPolicyContent';
  static const String termsOfServiceContent = 'termsOfServiceContent';
  static const String needHelp = 'needHelp';
  static const String supportEmail = 'supportEmail';
  static const String supportPhone = 'supportPhone';
  static const String supportWebsite = 'supportWebsite';
  static const String businessHours = 'businessHours';
  static const String sendEmailComingSoon = 'sendEmailComingSoon';
  static const String contactUs = 'contactUs';
  static const String resetPreferencesMessage = 'resetPreferencesMessage';
  static const String preferencesReset = 'preferencesReset';
  static const String reset = 'reset';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String website = 'website';

  // ========== LOT SCREENS ==========
  static const String treatLot = 'treatLot';
  static const String saleDate = 'saleDate';
  static const String buyerNameRequired = 'buyerNameRequired';
  static const String dateSlaughter = 'dateSlaughter';
  static const String nameOrEstablishment = 'nameOrEstablishment';
  static const String lotCreated = 'lotCreated';
  static const String source = 'source';
  static const String deleteLotQuestion = 'deleteLotQuestion';
  static const String lotDeleted = 'lotDeleted';
  static const String back = 'back';
  static const String copySuffix = 'copySuffix';
  static const String buyerFarmId = 'buyerFarmId';
  static const String slaughterhouseName = 'slaughterhouseName';
  static const String slaughterhouseId = 'slaughterhouseId';

  // ========== Slaughter SCREENS ==========
  static const String recordSlaughter = 'recordSlaughter';
  static const String animalsToSlaughter = 'animalsToSlaughter';
  static const String confirmSlaughter = 'confirmSlaughter';

  // ========== Slaughter SCREENS ==========
  static const String animalsForSale = 'animalsForSale';

  // ANIMAL FINDER
  static const String identifyAnimals = 'identifyAnimals';
  static const String animalAlreadyScanned = 'animalAlreadyScanned';
  static const String noAnimalAvailable = 'noAnimalAvailable';
  static const String searchEidOfficialVisual = 'searchEidOfficialVisual';
  static const String stop = 'stop';
  static const String scanRfid = 'scanRfid';
  static const String camera = 'camera';
  static const String done = 'done';
  static const String scanOrSearchAnimals = 'scanOrSearchAnimals';
  static const String selected = 'selected';
  static const String noAnimalFound = 'noAnimalFound';
  static const String tryAnotherIdentifier = 'tryAnotherIdentifier';
  static const String numberShort = 'numberShort';
  static const String idLabel = 'idLabel';
  static const String selectedAnimals = 'selectedAnimals';
  static const String scanMother = 'scanMother';

// ADD ANIMAL
  static const String identification = 'identification';
  static const String eidElectronic = 'eidElectronic';
  static const String atLeastOneIdRequired = 'atLeastOneIdRequired';
  static const String officialNumberOptional = 'officialNumberOptional';
  static const String visualIdOptional = 'visualIdOptional';
  static const String toIdentifyEasily = 'toIdentifyEasily';
  static const String typeAndBreed = 'typeAndBreed';
  static const String animalType = 'animalType';
  static const String animalTypeRequired = 'animalTypeRequired';
  static const String noBreed = 'noBreed';
  static const String selectTypeFirst = 'selectTypeFirst';
  static const String characteristics = 'characteristics';
  static const String origin = 'origin';
  static const String originRequired = 'originRequired';
  static const String birth = 'birth';
  static const String purchase = 'purchase';
  static const String provenance = 'provenance';
  static const String farmOrBreederName = 'farmOrBreederName';
  static const String purchasePrice = 'purchasePrice';
  static const String observationsRemarks = 'observationsRemarks';
  static const String saving = 'saving';
  static const String idScanned = 'idScanned';
  static const String motherMustBeFemale = 'motherMustBeFemale';
  static const String motherSelected = 'motherSelected';
  static const String atLeastOneIdRequiredError = 'atLeastOneIdRequiredError';
  static const String selectSexError = 'selectSexError';
  static const String selectBirthDateError = 'selectBirthDateError';
  static const String motherNotFound = 'motherNotFound';
  static const String animalSavedSuccess = 'animalSavedSuccess';
  static const String errorOccurred = 'errorOccurred';
  static const String eidOfMother = 'eidOfMother';
  static const String scanningInProgress = 'scanningInProgress';
  static const String noFemaleAvailable = 'noFemaleAvailable';
  static const String add = 'add';
  static const String motherAdded = 'motherAdded';
  static const String eidDetected = 'eidDetected';
  static const String placeRfidNear = 'placeRfidNear';
  static const String eidDetectedSuccess = 'eidDetectedSuccess';
  static const String eidScanned = 'eidScanned';
  static const String validate = 'validate';
  static const String exeIdVisuel = 'validate';

// ANIMAL DETAIL
  static const String infos = 'infos';
  static const String care = 'care';
  static const String genealogy = 'genealogy';
  static const String years = 'years';
  static const String statusAlive = 'statusAlive';
  static const String statusSold = 'statusSold';
  static const String statusDead = 'statusDead';
  static const String statusSlaughtered = 'statusSlaughtered';
  static const String weightInKg = 'weightInKg';
  static const String addWeightButton = 'addWeightButton';
  static const String weightAddedSuccess = 'weightAddedSuccess';
  static const String identifiers = 'identifiers';
  static const String changeEid = 'changeEid';
  static const String visualIdAnimal = 'visualIdAnimal';
  static const String show = 'show';
  static const String noEidHistory = 'noEidHistory';
  static const String generalInfo = 'generalInfo';
  static const String statusAnimal = 'statusAnimal';
  static const String noWeightRecorded = 'noWeightRecorded';
  static const String seeAll = 'seeAll';
  static const String kg = 'kg';
  static const String gain = 'gain';
  static const String loss = 'loss';
  static const String actions = 'actions';
  static const String recordWeight = 'recordWeight';
  static const String declareDeath = 'declareDeath';
  static const String noActiveAlert = 'noActiveAlert';
  static const String vaccinations = 'vaccinations';
  static const String noVaccination = 'noVaccination';
  static const String reminderLate = 'reminderLate';
  static const String reminderInDays = 'reminderInDays';
  static const String noMotherDeclared = 'noMotherDeclared';
  static const String motherDetected = 'motherDetected';
  static const String seeDetails = 'seeDetails';
  static const String offspring = 'offspring';
  static const String noOffspring = 'noOffspring';

  // ANIMAL LIST
  static const String allAnimals = 'allAnimals';
  static const String animalList = 'animalList';
  static const String urgent = 'urgent';
  static const String toMonitor = 'toMonitor';
  static const String routine = 'routine';
  static const String withdrawal = 'withdrawal';
  static const String apply = 'apply';
  static const String all = 'all';
  static const String active = 'active';
  static const String inactive = 'inactive';
  static const String motherEid = 'motherEid';
  static const String noAnimal = 'noAnimal';
  static const String searchEidOfficial = 'searchEidOfficial';
  static const String filters = 'filters';
  static const String groupBy = 'groupBy';
  static const String none = 'none';
  static const String withAlertsOnly = 'withAlertsOnly';
  static const String byAlert = 'byAlert';
  static const String bySex = 'bySex';
  static const String byAge = 'byAge';
  static const String byStatus = 'byStatus';
  static const String byWithdrawal = 'byWithdrawal';
  static const String byMother = 'byMother';
  static const String byType = 'byType';
  static const String byBreed = 'byBreed';

  // WEIGHT HISTORY
  static const String fullHistory = 'fullHistory';

  static const String scanQrEidVisual = 'scanQrEidVisual';
  static const String manualInput = 'manualInput';

  //BATCH
  static const String animalCount = 'animalCount';
  static const String continueScanning = 'continueScanning';
  static const String cancelBatch = 'cancelBatch';

  //section GENERAL ou NAVIGATION)
  static const String scan = 'scan';
  static const String home = 'home';

  // ========== BREEDING SPECIFICS ==========
  static const String breeding = 'breeding';
  static const String breedings = 'breedings';
  static const String noBreedings = 'noBreedings';
  static const String newBreeding = 'newBreeding';

// Breeding methods
  static const String breedingMethod = 'breedingMethod';
  static const String natural = 'natural';
  static const String artificialInsemination = 'artificialInsemination';

// Breeding dates
  static const String breedingDate = 'breedingDate';
  static const String expectedBirthDate = 'expectedBirthDate';
  static const String actualBirthDate = 'actualBirthDate';

// Breeding status (DIFFERENT from animal status)
  static const String breedingStatus = 'breedingStatus';
  static const String pending = 'pending';
  static const String completedBreeding = 'completedBreeding';
  static const String failedBreeding = 'failedBreeding';
  static const String abortedBreeding = 'abortedBreeding';

// Breeding data
  static const String father = 'father';
  static const String expectedOffspring = 'expectedOffspring';
  static const String actualOffspring = 'actualOffspring';
  static const String gestationDays = 'gestationDays';

// Breeding alerts
  static const String birthSoon = 'birthSoon';
  static const String overdue = 'overdue';
  static const String daysUntilBirth = 'daysUntilBirth';

  // Breeding actions
  static const String recordBreeding = 'recordBreeding';
  static const String recordBirth = 'recordBirth';
  static const String markAsFailed = 'markAsFailed';
  static const String markAsAborted = 'markAsAborted';
  static const String breedingRecorded = 'breedingRecorded';
  static const String birthRecorded = 'birthRecorded';

  // Statistics
  static const String successRate = 'successRate';
  static const String breedingThisMonth = 'breedingThisMonth';

  ////////////
  static const String animalsWithoutOfficialNumber =
      'animalsWithoutOfficialNumber';

  // ============ ANIMAL STATUS & DRAFT SYSTEM ============
  static const String draftStatus = 'draftStatus';
  static const String validatedStatus = 'validatedStatus';
  static const String deadStatus = 'deadStatus';
  static const String soldStatus = 'soldStatus';
  static const String slaughteredStatus = 'slaughteredStatus';
  
  // ============ DRAFT ALERTS & ACTIONS ============
  static const String draftAlertWarning = 'draftAlertWarning';
  static const String draftHardLimit = 'draftHardLimit';
  static const String cannotAddCareOnDraft = 'cannotAddCareOnDraft';
  static const String validateAnimal = 'validateAnimal';
  static const String confirmDelete = 'confirmDelete';
  static const String draftCreatedAt = 'draftCreatedAt';
  static const String validateFirst = 'validateFirst';
  static const String draftInBrouillon = 'draftInBrouillon';
  static const String draftModifiableUntilValidation = 'draftModifiableUntilValidation';
  static const String draftSinceHours = 'draftSinceHours';
  static const String animalsInAlert = 'animalsInAlert';
  static const String notAvailableDraft = 'notAvailableDraft';
  static const String animalUpdatedSuccess = 'animalUpdatedSuccess';

    // ============ ALERT CONFIGURATION KEYS ============
  static const String alertRemanenceTitle = 'alertRemanenceTitle';
  static const String alertRemanenceMsg = 'alertRemanenceMsg';

  static const String alertWeighingTitle = 'alertWeighingTitle';
  static const String alertWeighingMsg = 'alertWeighingMsg';

  static const String alertVaccinationTitle = 'alertVaccinationTitle';
  static const String alertVaccinationMsg = 'alertVaccinationMsg';

  static const String alertIdentificationTitle = 'alertIdentificationTitle';
  static const String alertIdentificationMsg = 'alertIdentificationMsg';

  static const String alertSyncTitle = 'alertSyncTitle';
  static const String alertSyncMsg = 'alertSyncMsg';

  static const String alertTreatmentTitle = 'alertTreatmentTitle';
  static const String alertTreatmentMsg = 'alertTreatmentMsg';

  static const String alertBatchTitle = 'alertBatchTitle';
  static const String alertBatchMsg = 'alertBatchMsg';

  // ============ BREEDING NOTES ============
  static const String breedingFailedNote = 'breedingFailedNote';
  static const String breedingAbortedNote = 'breedingAbortedNote';
  static const String reasonNotSpecified = 'reasonNotSpecified';

  // ============ LOT/MOVEMENT NOTES ============
  static const String buyerNoteLabel = 'buyerNoteLabel';
  static const String slaughterhouseNoteLabel = 'slaughterhouseNoteLabel';

  // ============ PHASE 1: ANIMAL DETAIL SCREEN ============
  static const String weightAddedMessage = 'weightAddedMessage';
  static const String draftModeBanner = 'draftModeBanner';
  static const String basicInformation = 'basicInformation';
  static const String createdOn = 'createdOn';
  static const String validatedOn = 'validatedOn';
  static const String typeAndBreedSection = 'typeAndBreedSection';
  static const String rfidIdentification = 'rfidIdentification';
  static const String eidChangesRecorded = 'eidChangesRecorded';
  static const String on = 'on';
  static const String doNotSlaughter = 'doNotSlaughter';
  static const String okForSlaughter = 'okForSlaughter';
  static const String validateAnimalTitle = 'validateAnimalTitle';
  static const String validateAnimalConfirm = 'validateAnimalConfirm';
  static const String animalValidatedSuccess = 'animalValidatedSuccess';
  static const String deleteAnimalTitle = 'deleteAnimalTitle';
  static const String deleteAnimalConfirm = 'deleteAnimalConfirm';
  static const String animalDeletedSuccess = 'animalDeletedSuccess';
  static const String noCareRecorded = 'noCareRecorded';
  static const String drPrefix = 'drPrefix';
  static const String withdrawalLabel = 'withdrawalLabel';
  static const String noWithdrawal = 'noWithdrawal';
  static const String activeAlert = 'activeAlert';
  static const String activeAlerts = 'activeAlerts';
  static const String priorityUrgent = 'priorityUrgent';
  static const String priorityImportant = 'priorityImportant';
  static const String priorityRoutine = 'priorityRoutine';

  // ============ PHASE 5: ANIMAL LIST SCREEN ============
  static const String drafts = 'drafts';
  static const String lessThan6Months = 'lessThan6Months';
  static const String from6To12Months = 'from6To12Months';
  static const String from1To2Years = 'from1To2Years';
  static const String moreThan2Years = 'moreThan2Years';
  static const String soldGroup = 'soldGroup';
  static const String deadGroup = 'deadGroup';
  static const String slaughteredGroup = 'slaughteredGroup';
  static const String withdrawalActive = 'withdrawalActive';
  static const String withdrawalInactive = 'withdrawalInactive';
  static const String unknownMother = 'unknownMother';
  static const String undefinedType = 'undefinedType';
  static const String undefinedBreed = 'undefinedBreed';
  static const String filtersLabel = 'filtersLabel';
  static const String noAnimalFoundMessage = 'noAnimalFoundMessage';
  static const String officialNumberNone = 'officialNumberNone';

  // ============ ACCOUNT SETTINGS SCREEN ============
  static const String myAccount = 'myAccount';
  static const String profile = 'profile';
  static const String password = 'password';
  static const String editProfile = 'editProfile';
  static const String fillAllFields = 'fillAllFields';
  static const String passwordsDoNotMatch = 'passwordsDoNotMatch';
  static const String passwordRequirements = 'passwordRequirements';

}
