//
//  Phone.swift
//  Phone Booth
//
//  Created by Tyler Sheft on 6/15/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import SwiftUI
import SwiftData
import SheftAppsStylishUI

@Model
final class Phone {
    
    // MARK: - Properties

	static var previewPhotoData: Data {
#if os(iOS) || os(visionOS)
		return getPNGDataFromUIImage(image: .phone)
#elseif os(macOS)
		return getPNGDataFromNSImage(image: .phone)
#endif
	}
    
    static let phoneColors: [Color.Named] = [
        .white, .black, .gray, .silver, .red, .orange, .yellow, .green, .blue, .purple, .pink, .champagneGold, .roseGold, .navyBlue
    ]
    
    static let backlightColors: [Color.Named] = [
        .white,
        .orange,
        .green,
        .blue
    ]
    
	var brand: String

	var model: String
	
	@Attribute(.externalStorage) var photoData: Data? = nil

	var releaseYear: Int = currentYear
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var baseMainColorName: Color.Named = Color.Named.black
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var baseSecondaryColorName: Color.Named = Color.Named.black
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var baseDisplayBacklightColorName: Color.Named = Color.Named.white
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var baseKeyForegroundColorName: Color.Named = Color.Named.white
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var baseKeyBackgroundColorName: Color.Named = Color.Named.black
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var cordedReceiverMainColorName: Color.Named = Color.Named.black
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var cordedReceiverSecondaryColorName: Color.Named = Color.Named.black
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var baseLEDMessageCounterColorName: Color.Named = Color.Named.white
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var baseKeyBacklightColorName: Color.Named = Color.Named.white
    
    var locatorButtons: Int = 0
    
    var deregistration: Int = 2
    
    var buttonType: Int = 0
    
    var chargeLight: Int = 0
	
	var cordedPhoneType: Int = 0
	
	var cordedRingerType: Int = 0
	
	var numberOfIncludedCordlessHandsets: Int = 1
	
	var maxCordlessHandsets: Int = 5
	
	var supportsRangeExtenders: Bool = false
	
	var hasTransmitOnlyBase: Bool = false
	
	var frequency: Int = 24

	@Relationship(deleteRule: .cascade, inverse: \CordlessHandset.phone)
	var cordlessHandsetsIHave: [CordlessHandset] = []
	
	@Relationship(deleteRule: .cascade, inverse: \Charger.phone)
	var chargersIHave: [Charger] = []
	
	var baseRingtones: Int = 1
	
	var baseMusicRingtones: Int = 0
	
    var baseIntercomRingtone: Int = 0
	
	var hasIntercom: Bool = true
	
	var hasBaseIntercom: Bool = false
	
	var numberOfLandlines: Int = 1
	
	var landlineInUseStatusOnBase: Int = 0
	
	var landlineInUseVisualRingerFollowsRingSignal: Bool = true
	
	var cellLineInUseStatusOnBase: Int = 0
	
	var cellLineOnlyBehavior: Int = 0
	
	var baseChargingDirection: Int = 0
	
	var baseHasSeparateDataContact: Bool = false
	
	var baseChargeContactPlacement: Int = 0
	
	var baseChargeContactMechanism: Int = 1
	
	var hasAnsweringSystem: Int = 3
	
	var answeringSystemMenuOnBase: Int = 0
	
	var greetingRecordingOnBaseOrHandset: Int = 1
	
	var hasMessageAlertByCall: Bool = false
	
	var hasGreetingOnlyMode: Bool = true
	
	var voicemailIndication: Int = 3
	
	var voicemailQuickDial: Int = 3

	var voicemailFeatureCodes: Bool = false

	var hasBaseSpeakerphone: Bool = false
	
	var hasBaseKeypad: Bool = false
	
	var hasTalkingCallerID: Bool = false
	
	var hasTalkingKeypad: Bool = false
	
	var hasTalkingPhonebook: Bool = false
	
	var baseDisplayType: Int = 0
	
	var baseHasDisplayAndMessageCounter: Bool = false
	
	var baseSoftKeysBottom: Int = 0
	
	var baseSoftKeysSide: Int = 0
	
	var baseNavigatorKeyType: Int = 0
	
	var baseNavigatorKeyStandbyShortcuts: Bool = false
	
	var baseNavigatorKeyCenterButton: Int = 0
	
	var baseNavigatorKeyLeftRightRepeatSkip: Bool = false
	
	var baseNavigatorKeyUpDownVolume: Bool = false
	
	var baseKeyBacklightAmount: Int = 0
	
	var cordedPowerSource: Int = 0
	
	var cordlessPowerBackupMode: Int = 0
	
	var cordlessPowerBackupReturnBehavior: Int = 0
	
	var baseSupportsWiredHeadsets: Bool = false
	
	var baseBluetoothHeadphonesSupported: Int = 0
	
	var baseBluetoothCellPhonesSupported: Int = 0
    
    var baseCellRingtone: Int = 1
	
	var bluetoothPhonebookTransfers: Int = 0
	
	var hasCellPhoneVoiceControl: Bool = false
	
	var basePhonebookCapacity: Int = 50
	
	var baseCallerIDCapacity: Int = 50
	
	var baseRedialCapacity: Int = 0
	
	var redialNameDisplay: Int = 0
	
	var callerIDPhonebookMatch: Bool = true
	
	var baseSpeedDialCapacity: Int = 0
	
	var baseOneTouchDialCapacity: Int = 0
	
	var oneTouchDialSupportsHandsetNumbers: Bool = false
	
	var speedDialPhonebookEntryMode: Int = 0
	
	var callBlockCapacity: Int = 1000
	
	var callBlockSupportsPrefixes: Bool = false
	
	var blockedCallersHear: Int = 0
	
	var hasFirstRingSuppression: Bool = true
	
	var hasOneTouchCallBlock: Bool = true
	
	var callBlockPreProgrammedDatabaseEntryCount: Int = 0
	
	var callBlockPreScreening: Int = 2
	
	var callBlockPreScreeningCustomGreeting: Bool = false
	
	var callBlockPreScreeningAllowedNameCapacity: Int = 100
	
	var callBlockPreScreeningAllowedNumberCapacity: Int = 100
	
	var callBlockPreScreeningAllowedNumberListVisible: Bool = true
	
	var roomMonitor: Int = 0
	
	var externalRoomMonitorAutomatedSystem: Int = 0
	
	var smartHomeDevicesSupported: Int = 0
	
	var answerByVoice: Bool = false
	
	var smartphonesAsHandsetsOverWiFi: Int = 0
	
	var scamCallDetection: Bool = false
	
	var placeOnBaseAutoRegister: Bool = true
	
	var wallMountability: Int = 1
	
	var antennas: Int = 0
	
	var phoneTypeText: String {
		if isCordedCordless {
            return PhoneType.cordedCordless.rawValue
		} else if isCordless {
			if hasTransmitOnlyBase {
                return PhoneType.cordlessWithTransmitOnlyBase.rawValue
			}
            return PhoneType.cordless.rawValue
		} else {
            return PhoneType.corded.rawValue
		}
	}
    
    var totalBaseRingtones: Int {
        return baseRingtones + baseMusicRingtones
    }
	
	var hasCordedReceiver: Bool {
        return cordedReceiverMainColorName != .clear
	}
	
	var isCordless: Bool {
		return numberOfIncludedCordlessHandsets > 0
	}
	
	var isCordedCordless: Bool {
		return isCordless && hasCordedReceiver
	}
    
    // MARK: - Initialization

	init(brand: String, model: String) {
		self.brand = brand
		self.model = model
	}
    
    // MARK: - Set Secondary Color to Main
    
    func setBaseSecondaryColorToMain() {
        baseSecondaryColorName = baseMainColorName
    }
    
    // MARK: - Property Change Handlers
	
	func transmitOnlyBaseChanged(oldValue: Bool, newValue: Bool) {
		if newValue {
			for handset in cordlessHandsetsIHave {
				handset.fitsOnBase = false
			}
			placeOnBaseAutoRegister = false
			baseHasSeparateDataContact = false
			baseChargeContactMechanism = 0
			baseChargeContactPlacement = 0
			baseChargingDirection = 0
			if cordlessPowerBackupMode == 1 {
				cordlessPowerBackupMode = 0
			}
		}
	}
	
	func isCordlessChanged(oldValue: Bool, newValue: Bool) {
		if newValue {
			cordedPhoneType = 0
			cordedRingerType = 1
		} else {
			if hasAnsweringSystem > 1 {
				hasAnsweringSystem = 1
			}
            hasIntercom = false
            baseIntercomRingtone = 0
			placeOnBaseAutoRegister = false
			hasTransmitOnlyBase = false
			supportsRangeExtenders = false
			baseChargingDirection = 0
			baseChargeContactMechanism = 0
			baseChargeContactPlacement = 0
			baseHasSeparateDataContact = false
			cordlessHandsetsIHave.removeAll()
			chargersIHave.removeAll()
		}
	}
    
    func totalBaseRingtonesChanged(oldValue: Int, newValue: Int) {
        guard isCordless else { return }
        if newValue < oldValue && (baseIntercomRingtone >= (totalBaseRingtones + 1) || baseIntercomRingtone == 1) {
            baseIntercomRingtone -= 1
        }
    }
	
	func baseDisplayTypeChanged(oldValue: Int, newValue: Int) {
		if newValue == 0 {
			hasTalkingPhonebook = false
            baseNavigatorKeyType = 0
            baseNavigatorKeyCenterButton = 0
            baseNavigatorKeyStandbyShortcuts = false
		}
		if newValue <= 1 {
			baseSoftKeysBottom = 0
			baseSoftKeysSide = 0
		}
		if newValue < 3 || newValue > 5 {
            baseDisplayBacklightColorName = .white
		}
	}
    
    func baseNavigatorKeyTypeChanged(oldValue: Int, newValue: Int) {
        if newValue == 0 {
            baseNavigatorKeyCenterButton = 0
            baseNavigatorKeyUpDownVolume = false
            baseNavigatorKeyLeftRightRepeatSkip = false
            baseNavigatorKeyStandbyShortcuts = false
        }
    }
	
	func maxCordlessHandsetsChanged(oldValue: Int, newValue: Int) {
		if newValue == -1 {
			placeOnBaseAutoRegister = false
			deregistration = 0
			locatorButtons = 0
			for handset in cordlessHandsetsIHave {
				handset.fitsOnBase = true
			}
		}
		if newValue == 0 && oldValue == -1 {
			maxCordlessHandsets = 1
		} else if newValue == 0 && oldValue == 1 {
			maxCordlessHandsets = -1
		}
	}
	
	func baseSoftKeysBottomChanged(oldValue: Int, newValue: Int) {
		if oldValue == 0 && newValue == 1 {
			baseSoftKeysBottom = 2
		} else if oldValue == 2 && newValue == 1 {
			baseSoftKeysBottom = 0
		}
	}
	
	func baseSoftKeysSideChanged(oldValue: Int, newValue: Int) {
		if oldValue == 0 && newValue == 1 {
			baseSoftKeysSide = 2
		} else if oldValue == 2 && newValue == 1 {
			baseSoftKeysSide = 0
		}
	}
    
    func hasBaseKeypadChanged(oldValue: Bool, newValue: Bool) {
        if newValue && baseCellRingtone == 0 {
            baseCellRingtone = 1
        }
    }
    
    func hasBaseSpeakerphoneChanged(oldValue: Bool, newValue: Bool) {
        if newValue {
            hasBaseIntercom = true
        }
    }
	
	func baseBluetoothCellPhonesSupportedChanged(oldValue: Int, newValue: Int) {
		if oldValue == 0 && newValue > 0 {
			bluetoothPhonebookTransfers = 1
		}
	}
	
	func cordlessPowerBackupModeChanged(oldValue: Int, newValue: Int) {
		if newValue != 1 {
			cordlessPowerBackupReturnBehavior = 0
		}
	}
	
	func locatorButtonsChanged(oldValue: Int, newValue: Int) {
		if newValue == 0 {
			deregistration = 1
		}
	}
	
	func cordedReceiverColorChanged(oldValue: Color.Named, newValue: Color.Named) {
        if newValue.value != .clear {
			for handset in cordlessHandsetsIHave {
				handset.fitsOnBase = false
			}
			placeOnBaseAutoRegister = false
			hasTransmitOnlyBase = false
			baseChargingDirection = 0
			baseChargeContactMechanism = 0
			baseChargeContactPlacement = 0
		}
	}
	
	func cordedPhoneTypeChanged(oldValue: Int, newValue: Int) {
		if newValue != 0 {
			hasBaseSpeakerphone = false
			hasTalkingKeypad = false
			hasTalkingPhonebook = false
			hasAnsweringSystem = 0
			baseMusicRingtones = 0
			basePhonebookCapacity = 0
			baseBluetoothHeadphonesSupported = 0
			baseBluetoothCellPhonesSupported = 0
			hasTalkingCallerID = false
		}
		if newValue == 1 || newValue == 3 {
			baseRedialCapacity = 0
			baseSpeedDialCapacity = 0
			baseCallerIDCapacity = 0
			baseDisplayType = 0
			baseSoftKeysSide = 0
			baseSoftKeysBottom = 0
			baseDisplayType = 0
		}
	}
	
	func cordedRingerTypeChanged(oldValue: Int, newValue: Int) {
		if newValue == 0 {
			hasBaseSpeakerphone = false
			hasAnsweringSystem = 0
			baseRingtones = 0
			baseMusicRingtones = 0
			basePhonebookCapacity = 0
			baseCallerIDCapacity = 0
			baseBluetoothHeadphonesSupported = 0
			baseBluetoothCellPhonesSupported = 0
			hasTalkingCallerID = false
			hasTalkingKeypad = false
			hasTalkingPhonebook = false
		}
	}
	
	func deregistrationChanged(oldValue: Int, newValue: Int) {
		if newValue == 0 {
			placeOnBaseAutoRegister = false
		}
	}
	
}
