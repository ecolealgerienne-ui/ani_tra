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

  // ============ FARM PREFERENCES ============
  static const String farmPreferencesTitle = 'farmPreferencesTitle';
  static const String farmPreferencesSubtitle = 'farmPreferencesSubtitle';
  static const String defaultAnimalType = 'defaultAnimalType';
  static const String defaultBreed = 'defaultBreed';
  static const String noBreedSelected = 'noBreedSelected';
  static const String farmPreferencesInfo = 'farmPreferencesInfo';
  static const String noBreedAvailable = 'noBreedAvailable';
  static const String noneChooseEachTime = 'noneChooseEachTime';

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
}
