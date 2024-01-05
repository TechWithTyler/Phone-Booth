//
//  CordlessHandset.swift
//  Phone Booth
//
//  Created by Tyler Sheft on 6/28/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import SheftAppsStylishUI
import SwiftUI
import SwiftData

@Model
final class CordlessHandset {
    
    // MARK: - Properties
    
    var id = UUID()
    
    var phone: Phone?
    
    var brand: String
    
    var model: String
    
    var releaseYear: Int = currentYear
    
    var fitsOnBase: Bool = true
    
    var maxBases: Int = 1
    
    var cordlessDeviceType: Int = 0
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var mainColorName: Color.Named = Color.Named.black
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var secondaryColorName: Color.Named = Color.Named.black
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var displayBacklightColorName: Color.Named = Color.Named.white
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var keyForegroundColorName: Color.Named = Color.Named.white
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var keyBackgroundColorName: Color.Named = Color.Named.black
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var cordedReceiverMainColorName: Color.Named = Color.Named.black
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var cordedReceiverSecondaryColorName: Color.Named = Color.Named.black
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var keyBacklightColorName: Color.Named = Color.Named.white
    
    var buttonType: Int = 0
    
    var displayType: Int = 2
    
    var menuUpdateMode: Int = 0
    
    var hasSpeakerphone: Bool = true
    
    var lineButtons: Int = 0
    
    var visualRinger: Int = 0
    
    var ringtones: Int = 5
    
    var musicRingtones: Int = 5
    
    var intercomRingtone: Int = 0
    
    var oneTouchDialCapacity: Int = 0
    
    var speedDialCapacity: Int = 0
    
    var redialCapacity: Int = 5
    
    var softKeys: Int = 0
    
    var navigatorKeyType: Int = 1
    
    var navigatorKeyUpDownVolume: Bool = true
    
    var navigatorKeyStandbyShortcuts: Bool = true
    
    var navigatorKeyCenterButton: Int = 1
    
    var sideVolumeButtons: Bool = false
    
    var keyBacklightAmount: Int = 0
    
    var supportsWiredHeadsets: Bool = false
    
    var answeringSystemMenu: Int = 3
    
    var phonebookCapacity: Int = 0
    
    var callerIDPhonebookMatch: Bool = false
    
    var usesBasePhonebook: Bool = true
    
    var usesBaseCallerID: Bool = true
    
    var usesBaseSpeedDial: Bool = false
    
    var usesBaseOneTouchDial: Bool = false
    
    var speedDialPhonebookEntryMode: Int = 0
    
    var redialNameDisplay: Int = 0
    
    var bluetoothHeadphonesSupported: Int = 0
    
    var bluetoothPhonebookTransfers: Int = 0
    
    var callerIDCapacity: Int = 0
    
    var keyFindersSupported: Int = 0
    
    var antenna: Int = 0
    
    var hasTalkingCallerID: Bool = false
    
    var hasTalkingKeypad: Bool = false
    
    var hasTalkingPhonebook: Bool = false
    
    var totalRingtones: Int {
        return ringtones + musicRingtones
    }
    
    // MARK: - Initialization
    
    init(brand: String, model: String) {
        self.brand = brand
        self.model = model
    }
    
    // MARK: - Set Secondary Color to Main
    
    func setSecondaryColorToMain() {
        secondaryColorName = mainColorName
    }
    
    // MARK: - Property Change Handlers
    
    func cordlessDeviceTypeChanged(oldValue: Int, newValue: Int) {
        if newValue > 0 {
            fitsOnBase = false
        }
    }
    
    func totalRingtonesChanged(oldValue: Int, newValue: Int) {
        if newValue < oldValue && (intercomRingtone >= (totalRingtones + 1) || intercomRingtone == 1) {
            intercomRingtone -= 1
        }
    }
    
    func displayTypeChanged(oldValue: Int, newValue: Int) {
        if newValue == 0 {
            hasTalkingPhonebook = false
        }
        if newValue <= 1 {
            softKeys = 0
        }
        if newValue == 5 {
            displayBacklightColorName = .white
        }
        if newValue == 0 {
            displayBacklightColorName = .white
            menuUpdateMode = 0
            navigatorKeyType = 0
            navigatorKeyCenterButton = 0
        }
    }
    
    func softKeysChanged(oldValue: Int, newValue: Int) {
        if oldValue == 0 && newValue == 1 {
            softKeys = 2
        } else if oldValue == 2 && newValue == 1 {
            softKeys = 0
        }
        if newValue < 3 && navigatorKeyCenterButton == 3 {
            navigatorKeyCenterButton = 2
        }
        if newValue == 0 {
            lineButtons = 0
        }
    }
    
    func sideVolumeButtonsChanged(oldValue: Bool, newValue: Bool) {
        if !newValue {
            navigatorKeyUpDownVolume = true
        }
    }
    
    func navigatorKeyTypeChanged(oldValue: Int, newValue: Int) {
        if newValue == 0 {
            navigatorKeyCenterButton = 0
            navigatorKeyUpDownVolume = false
            sideVolumeButtons = true
            navigatorKeyStandbyShortcuts = false
        }
    }
    
    func callerIDCapacityChanged(oldValue: Int, newValue: Int) {
        if newValue > 0 {
            usesBaseCallerID = false
        }
    }
    
}
