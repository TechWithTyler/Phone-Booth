//
//  PhoneDetailView.swift
//  Phone Booth
//
//  Created by Tyler Sheft on 6/16/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import SwiftUI
import SwiftData
import PhotosUI
import SheftAppsStylishUI

struct PhoneDetailView: View {
    
    // MARK: - Properties - Objects
    
    @Bindable var phone: Phone
    
    @EnvironmentObject var photoViewModel: PhonePhotoViewModel
    
    // MARK: - Properties - Booleans
    
    @State private var showingFrequenciesExplanation: Bool = false
    
    @State private var showingPhoneTypeDefinitions: Bool = false
    
    @State private var selectedColor: Color.Named = .red
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("General")) {
                    photo(for: phone)
                    FormTextField("Brand", text: $phone.brand)
                    FormTextField("Model", text: $phone.model)
                    HStack {
                        Text("Phone type: \(phone.phoneTypeText)")
                        Spacer()
                        InfoButton {
                            showingPhoneTypeDefinitions = true
                        }
                    }
                    Stepper("Release Year: \(String(phone.releaseYear))", value: $phone.releaseYear, in: 1892...currentYear)
                }
                PhonePartInfoView(phone: phone)
                    Section("Basic Features/Cordless Capabilities") {
                    Stepper("Number of Included Cordless Handsets (0 if corded only): \(phone.numberOfIncludedCordlessHandsets)", value: $phone.numberOfIncludedCordlessHandsets, in: 0...Int.max-1)
                        .onChange(of: phone.isCordless) { oldValue, newValue in
                            phone.isCordlessChanged(oldValue: oldValue, newValue: newValue)
                        }
                    if phone.isCordless {
                        Group {
                            Stepper("Maximum Number of Cordless Handsets (-1 if using \"security codes must match\"): \(phone.maxCordlessHandsets)", value: $phone.maxCordlessHandsets, in: -1...15)
                                .onChange(of: phone.maxCordlessHandsets) { oldValue, newValue in
                                    phone.maxCordlessHandsetsChanged(oldValue: oldValue, newValue: newValue)
                                }
                                .sensoryFeedback(.error, trigger: phone.numberOfIncludedCordlessHandsets) { oldValue, newValue in
                                    return newValue > phone.maxCordlessHandsets && phone.maxCordlessHandsets != -1
                                }
                            if phone.maxCordlessHandsets == -1 {
                                InfoText("When placing the handset on the base, the handset and base exchange a digital security code, which makes sure the handset only communicates with that base. You can add as many handsets as you want--the base doesn't know or care how many handsets are being used on it.")
                            }
                            if phone.numberOfIncludedCordlessHandsets > phone.maxCordlessHandsets && phone.maxCordlessHandsets != -1 {
                                WarningText("The base of the \(phone.brand) \(phone.model) can only register up to \(phone.maxCordlessHandsets) handsets (trying to register \(phone.numberOfIncludedCordlessHandsets)).")
                            }
                        }
                    if phone.isCordless {
                        Picker("Wireless Frequency", selection: $phone.frequency) {
                            Section(header: Text("46-49MHz")) {
                                Text("46-49MHz Analog or Older").tag(0)
                            }
                            Section(header: Text("900MHz")) {
                                Text("900MHz Analog").tag(1)
                                Text("900MHz Voice Scramble Analog").tag(2)
                                Text("900MHz Digital").tag(3)
                                Text("900MHz Digital Spread Spectrum (DSS)").tag(4)
                            }
                            Section(header: Text("2.4GHz")) {
                                Text("2.4GHz Analog").tag(5)
                                Text("2.4GHz/900MHz Analog").tag(6)
                                Text("2.4GHz Digital").tag(7)
                                Text("2.4GHz/900MHz Digital").tag(8)
                                Text("2.4GHz Digital Spread Spectrum (DSS)").tag(9)
                                Text("2.4GHz/900MHz Digital Spread Spectrum (DSS)").tag(10)
                                Text("2.4GHz Digital Frequency-Hopping Spread Spectrum (FHSS)").tag(11)
                                Text("2.4GHz/900MHz Digital Frequency-Hopping Spread Spectrum (FHSS)").tag(12)
                            }
                            Section(header: Text("5.8GHz")) {
                                Text("5.8GHz Analog").tag(13)
                                Text("5.8GHz/900MHz Analog").tag(14)
                                Text("5.8GHz/2.4GHz Analog").tag(15)
                                Text("5.8GHz Digital").tag(16)
                                Text("5.8GHz/900MHz Digital").tag(17)
                                Text("5.8GHz/2.4GHz Digital").tag(18)
                                Text("5.8GHz Digital Spread Spectrum (DSS)").tag(19)
                                Text("5.8GHz/900MHz Digital Spread Spectrum (DSS)").tag(20)
                                Text("5.8GHz/2.4GHz Digital Spread Spectrum (DSS)").tag(21)
                                Text("5.8GHz Digital Frequency-Hopping Spread Spectrum (FHSS)").tag(22)
                                Text("5.8GHz/900MHz Digital Frequency-Hopping Spread Spectrum (FHSS)").tag(23)
                                Text("5.8GHz/2.4GHz Digital Frequency-Hopping Spread Spectrum (FHSS)").tag(24)
                            }
                            Section(header: Text("DECT (Digital Enhanced Cordless Telecommunications)")) {
                                Text("DECT (1.88GHz-1.90GHz)").tag(25)
                                Text("DECT (1.90GHz-1.92GHz)").tag(26)
                                Text("DECT 6.0 (1.92GHz-1.93GHz)").tag(27)
                            }
                        }
                        InfoButton(title: "Frequencies Explanation…") {
                            showingFrequenciesExplanation = true
                        }
                        Picker("Antennas", selection: $phone.antennas) {
                            Text("Hidden").tag(0)
                            Text("Telescopic").tag(1)
                            Text("Standard (left)").tag(2)
                            Text("Standard (right)").tag(3)
                            Text("One On Each Side").tag(4)
                        }
                        AntennaInfoView()
                        Toggle("Supports Range Extenders", isOn: $phone.supportsRangeExtenders)
                        InfoText("A range extender extends the range of the base its registered to. Devices communicating with the base choose the base or a range extender based on which has the strongest signal.")
                        if !phone.isCordedCordless {
                            Toggle("Base Is Transmit-Only", isOn: $phone.hasTransmitOnlyBase)
                            InfoText("A transmit-only base doesn't have a charging area for a cordless handset nor does it have a corded receiver. Sometimes these kinds of bases have speakerphone, but usually they only have a locator button and nothing else. A transmit-only base with no features on it is often called a \"hidden base\" as these kinds of bases are often placed out-of-sight.")
                                .onChange(of: phone.hasTransmitOnlyBase) { oldValue, newValue in
                                    phone.transmitOnlyBaseChanged(oldValue: oldValue, newValue: newValue)
                                }
                            Picker("Wall Mounting", selection: $phone.wallMountability) {
                                Text("Not Supported").tag(0)
                                Text("Holes on Back").tag(1)
                                Text("Optional Bracket").tag(2)
                                Text("Built-In Bracket").tag(3)
                                Text("Desk/Wall Bracket").tag(4)
                            }
                        }
                    } else {
                        Picker("Corded Phone Type", selection: $phone.cordedPhoneType) {
                            Section(header: Text("Desk")) {
                                Text("Push-Button Desk").tag(0)
                                Text("Rotary Desk").tag(1)
                            }
                            Section(header: Text("Slim/Wall")) {
                                Text("Push-Button Slim/Wall").tag(2)
                                Text("Rotary Slim/Wall").tag(3)
                            }
                        }
                        .onChange(of: phone.cordedPhoneType) { oldValue, newValue in
                            phone.cordedPhoneTypeChanged(oldValue: oldValue, newValue: newValue)
                        }
                    }
                        Picker("Charge Light", selection: $phone.chargeLight) {
                            Text("None").tag(0)
                            if !phone.hasTransmitOnlyBase {
                                Text("On Base Only").tag(1)
                                Text("On Base/Charger").tag(2)
                            } else {
                                Text("On Charger").tag(2)
                            }
                            Text("On Handset").tag(3)
                        }
                        if !phone.hasTransmitOnlyBase {
                            Group {
                                Picker("Base Charging Direction", selection: $phone.baseChargingDirection) {
                                    Text("Forward (stand up)").tag(0)
                                    Text("Forward (lean back)").tag(1)
                                    Text("Forward (lay down)").tag(2)
                                    Text("Backward (lay down)").tag(3)
                                    Text("Backward (stand up)").tag(4)
                                    Text("Backward (lean back)").tag(5)
                                    Text("Forward Stand Up or Backward Lay Down").tag(6)
                                    Text("Forward Or Backward Lay Down (reversible handset)").tag(7)
                                }
                                if !phone.isCordedCordless {
                                    Picker("Base Charge Contact Placement", selection: $phone.baseChargeContactPlacement) {
                                        Text("Bottom").tag(0)
                                        Text("Back").tag(1)
                                        Text("One On Each Side").tag(2)
                                    }
                                    Picker("Base Charge Contact Mechanism", selection: $phone.baseChargeContactMechanism) {
                                        Text("Press Down").tag(0)
                                        Text("Click").tag(1)
                                        Text("Inductive").tag(2)
                                    }
                                    ChargingContactInfoView()
                                    Toggle("Base Has Separate Data Contact", isOn: $phone.baseHasSeparateDataContact)
                                    InfoText("""
  Most modern cordless phones pass data through the 2 charging contacts for various features including the following. However, many older cordless phones, especially 46-49MHz and 900MHz models, used a separate, 3rd contact for data.
  • Detecting the handset being placed on the base for registration.
  • Detecting the handset being lifted off the base to switch from the base speakerphone to the handset.
  In most cases, if the base has a charge light, the completion of the charge circuit turns it on, but sometimes that's handled by the separate data contact if the phone has one.
  """)
                                }
                            }
                        }
                        if phone.maxCordlessHandsets != -1 {
                            Picker("Handset Locator", selection: $phone.locatorButtons) {
                                Text(phone.hasBaseKeypad ? "One For All Handsets/Keypad Entry" : "One For All Handsets").tag(0)
                                Text("One For Each Handset").tag(1)
                                Text("Select + Call Buttons").tag(2)
                            }
                            .onChange(of: phone.locatorButtons) { oldValue, newValue in
                                phone.locatorButtonsChanged(oldValue: oldValue, newValue: newValue)
                            }
                            if !phone.isCordedCordless && !phone.hasTransmitOnlyBase && phone.deregistration > 0 {
                                Toggle("Place-On-Base Auto-Register", isOn: $phone.placeOnBaseAutoRegister)
                                InfoText("The base can detect an unregistered handset being placed on it, which will put it into registration mode. Aside from putting the base into registration mode, data isn't exchanged through the contacts like it is on phones using the digital security code method. Manually putting the base in registration mode is still available for re-registering handsets or for registering handsets which don't fit in the base.")
                            }
                            Picker("Deregistration", selection: $phone.deregistration) {
                                if phone.locatorButtons > 0 {
                                    Text("Not Supported").tag(0)
                                }
                                Text("From This Handset").tag(1)
                                Text("One From Any Handset/Base").tag(2)
                                Text("Multiple From Any Handset/Base").tag(3)
                                Text("All From Base").tag(4)
                            }
                            .onChange(of: phone.deregistration) { oldValue, newValue in
                                phone.deregistrationChanged(oldValue: oldValue, newValue: newValue)
                            }
                        }
                    }
                }
                Section(header: Text("Power")) {
                    if !phone.isCordless {
                        Picker("Power Source", selection: $phone.cordedPowerSource) {
                            Text("Line Power Only").tag(0)
                            Text("Batteries").tag(1)
                            Text("AC Power").tag(2)
                            Text("AC Power with Battery Backup (non-recharging)").tag(3)
                            Text("AC Power with Battery Backup (recharging)").tag(4)
                        }
                    }
                    if phone.isCordless {
                        Picker("Power Backup", selection: $phone.cordlessPowerBackupMode) {
                            Text("External Battery Backup (if available)").tag(0)
                            if phone.isCordedCordless {
                                Text("Line Power").tag(1)
                            } else {
                                if !phone.hasTransmitOnlyBase {
                                    Text("Place Handset On Base").tag(1)
                                }
                            }
                            Text("Batteries in Base (non-recharging)").tag(2)
                            Text("Batteries in Base (recharging)").tag(3)
                        }
                        .onChange(of: phone.cordlessPowerBackupMode) { oldValue, newValue in
                            phone.cordlessPowerBackupModeChanged(oldValue: oldValue, newValue: newValue)
                        }
                        if phone.cordlessPowerBackupMode == 0 {
                            InfoText("You can plug an external battery into the base power port to use it when the power goes out.")
                        }
                        if phone.cordlessPowerBackupMode == 3 {
                            WarningText("If you use non-rechargeable batteries, you MUST remember to remove them from the base as soon as possible once power returns to prevent leakage!")
                        }
                        if phone.cordlessPowerBackupMode == 1 && !phone.hasTransmitOnlyBase && !phone.isCordedCordless {
                            Picker("When Power Returns", selection: $phone.cordlessPowerBackupReturnBehavior) {
                                Text("Reboot/Refresh Handset Menus").tag(0)
                                Text("Restore Full Functionality Without Rebooting").tag(1)
                            }
                            VStack(alignment: .leading) {
                                InfoText("When the power goes out, placing a charged handset on the base can give it power. None of the base buttons will work. However, the display/lights may flash to indicate the base is booting up. Features like the answering system and base Bluetooth aren't available while the handset is powering the base. This helps to conserve handset battery power.")
                                if phone.cordlessHandsetsIHave.filter({$0.fitsOnBase}).isEmpty {
                                    WarningText("You must have at least one handset which fits on the base to use power backup!")
                                }
                            }
                        }
                    }
                }
                if phone.isCordless || phone.cordedPhoneType == 0 {
                    Section(header: Text("Speakerphone/Intercom/Base Keypad")) {
                        if !phone.isCordedCordless {
                            Toggle(isOn: $phone.hasBaseSpeakerphone) {
                                Text("Has Base Speakerphone")
                            }
                            .onChange(of: phone.hasBaseSpeakerphone) { oldValue, newValue in
                                phone.hasBaseSpeakerphoneChanged(oldValue: oldValue, newValue: newValue)
                            }
                        }
                        if !phone.isCordless || (phone.isCordless && phone.hasBaseSpeakerphone) {
                            Toggle(isOn: $phone.hasBaseKeypad) {
                                Text("Has Base Keypad")
                            }
                            InfoText("Some cordless phones have a base speakerphone and keypad, which allows you to make calls if the handset isn't nearby or if it needs to charge. Bases with keypads are a great option for office spaces.")
                            if phone.hasBaseKeypad {
                                Toggle(isOn: $phone.hasTalkingKeypad) {
                                    Text("Talking Keypad")
                                }
                                InfoText("The phone can announce the keys you press when dialing numbers.")
                            }
                        }
                        if phone.isCordless {
                            Toggle(isOn: $phone.hasIntercom) {
                                Text("Has Intercom")
                            }
                            if phone.hasIntercom && !phone.hasBaseSpeakerphone && !phone.isCordedCordless {
                                Toggle(isOn: $phone.hasBaseIntercom) {
                                    Text("Has Base Intercom")
                                }
                            }
                            if phone.hasIntercom && !phone.hasBaseIntercom && phone.cordlessHandsetsIHave.count <= 1 {
                                Text("Intercom requires 2 or more handsets to be registered to the base.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                Section(header: Text("Ringers")) {
                    if (phone.hasAnsweringSystem == 1 || phone.hasAnsweringSystem == 3) || phone.hasBaseSpeakerphone {
                        Stepper("Base Ringtones: \(phone.baseRingtones)", value: $phone.baseRingtones, in: !phone.isCordless || phone.hasBaseSpeakerphone ? 1...25 : 0...25)
                        if phone.baseRingtones > 0 {
                            Stepper("Base Music Ringtones: \(phone.baseMusicRingtones)", value: $phone.baseMusicRingtones, in: 0...25)
                        }
                        Text("Total Ringtones: \(phone.totalBaseRingtones)")
                    }
                    else if !phone.isCordless && (phone.cordedPhoneType == 0 || phone.cordedPhoneType == 2) {
                        Picker("Ringer Type", selection: $phone.cordedRingerType) {
                            Text("Bell/Mechanical").tag(0)
                            Text("Electronic").tag(1)
                        }
                        InfoText("A bell/mechanical ringer requires more power to ring, so it may not work properly on most VoIP lines, especially if multiple phones are ringing at once, as they're usually designed for modern phones which typically don't have mechanical ringers. Electronic ringers, especially those that are software-driven, don't require much power. The amount of ringing power a phone requires is determined by the Ringer Equivalence Number (REN), usually found on the bottom of the phone. A higher REN means more power required to ring.")
                    }
                    if phone.isCordless && phone.hasBaseIntercom && phone.baseRingtones > 0 {
                        Picker("Base Intercom Ringtone", selection: $phone.baseIntercomRingtone) {
                            Text("Intercom-Specific Ringtone/Beep").tag(0)
                            if phone.totalBaseRingtones > 1 {
                                Text("Selectable Ringtone").tag(1)
                            }
                            ForEach(0..<phone.totalBaseRingtones, id: \.self) { ringtoneNumber in
                                Text("Tone \(ringtoneNumber+1)").tag(ringtoneNumber + 2)
                            }
                        }
                        .onChange(of: phone.totalBaseRingtones) {
                            oldValue, newValue in
                            phone.totalBaseRingtonesChanged(oldValue: oldValue, newValue: newValue)
                        }
                    }
                    if phone.baseBluetoothCellPhonesSupported > 0 && phone.totalBaseRingtones == 1 {
                        Picker("Base Cell Line Ringtone", selection: $phone.baseCellRingtone) {
                            if !phone.hasBaseKeypad {
                                Text("None").tag(0)
                            }
                            Text("Landline Ringtone").tag(1)
                            Text("Cell Line-Specific Ringtone").tag(2)
                        }
                        .onChange(of: phone.hasBaseKeypad) {
                            oldValue, newValue in
                            phone.hasBaseKeypadChanged(oldValue: oldValue, newValue: newValue)
                        }
                    }
                }
                if phone.isCordless || phone.cordedPhoneType == 0 {
                    Section(header: Text("Display/Backlight/Buttons")) {
                        Picker("Button Type", selection: $phone.buttonType) {
                            Text("Spaced").tag(0)
                            Text("Spaced with Click Feel").tag(1)
                            Text("Some Spaced, Some Diamond-Cut").tag(2)
                            Text("Some Spaced with Click Feel, Some Diamond-Cut").tag(3)
                            Text("Diamond-Cut (no space between buttons, click feel)").tag(4)
                        }
                        Picker(phone.isCordless ? "Display Type (base)" : "Display Type", selection: $phone.baseDisplayType) {
                            Text("None").tag(0)
                            if phone.hasAnsweringSystem == 1 || phone.hasAnsweringSystem == 3 {
                                Text("LED Message Counter").tag(1)
                                Text("LCD Message Counter With Status Items").tag(2)
                            }
                            Text("Monochrome Display (traditional)").tag(3)
                            Text("Monochrome Display (full-dot with status items)").tag(4)
                            Text("Monochrome Display (full-dot)").tag(5)
                            Text("Color Display").tag(6)
                        }
                        .onChange(of: phone.baseDisplayType) { oldValue, newValue in
                            phone.baseDisplayTypeChanged(oldValue: oldValue, newValue: newValue)
                        }
                        if phone.baseDisplayType > 2 && phone.baseDisplayType < 6 {
                            ListColorPicker("Base Display Backlight Color", colors: Phone.backlightColors, selection: $phone.baseDisplayBacklightColorName)
                        }
                        if phone.baseDisplayType >= 3 {
                            Toggle("Base Has LED Message Counter In Addition To Display", isOn: $phone.baseHasDisplayAndMessageCounter)
                        }
                        if phone.baseDisplayType == 1 || phone.baseHasDisplayAndMessageCounter {
                            ListColorPicker("LED Message Counter Color", colors: Phone.backlightColors, selection: $phone.baseLEDMessageCounterColorName)
                        }
                        if phone.baseDisplayType > 0 {
                            Picker("Base Navigation Button Type", selection: $phone.baseNavigatorKeyType) {
                                Text("None").tag(0)
                                Text("Up/Down").tag(1)
                                Text("Up/Down/Left/Right").tag(3)
                            }
                            .onChange(of: phone.baseNavigatorKeyType) { oldValue, newValue in
                                phone.baseNavigatorKeyTypeChanged(oldValue: oldValue, newValue: newValue)
                            }
                            if phone.baseNavigatorKeyType > 0 {
                                Picker("Base Navigation Button Center Button", selection: $phone.baseNavigatorKeyCenterButton) {
                                    Text("None").tag(0)
                                    Text("Select").tag(1)
                                    Text("Menu/Select").tag(2)
                                    if phone.hasAnsweringSystem == 1 || phone.hasAnsweringSystem == 3 {
                                        Text("Play/Stop").tag(3)
                                        Text("Play/Select").tag(4)
                                        Text("Play/Stop/Select").tag(5)
                                    }
                                    Text("Other Function").tag(6)
                                }
                                Toggle("Base Navigation Button Up/Down for Volume", isOn: $phone.baseNavigatorKeyUpDownVolume)
                                if phone.hasAnsweringSystem == 1 || phone.hasAnsweringSystem == 3 {
                                    Toggle("Base Navigation Button Left/Right for Repeat/Skip", isOn: $phone.baseNavigatorKeyLeftRightRepeatSkip)
                                }
                                Toggle("Base Navigation Button Standby Shortcuts", isOn: $phone.baseNavigatorKeyStandbyShortcuts)
                            }
                            if phone.baseDisplayType > 2 {
                                Stepper("Base Soft Keys (bottom): \(phone.baseSoftKeysBottom)", value: $phone.baseSoftKeysBottom, in: 0...4)
                                    .onChange(of: phone.baseSoftKeysBottom) { oldValue, newValue in
                                        phone.baseSoftKeysBottomChanged(oldValue: oldValue, newValue: newValue)
                                    }
                                Stepper("Base Soft Keys (side): \(phone.baseSoftKeysSide)", value: $phone.baseSoftKeysSide, in: 0...3)
                                    .onChange(of: phone.baseSoftKeysSide) { oldValue, newValue in
                                        phone.baseSoftKeysSideChanged(oldValue: oldValue, newValue: newValue)
                                    }
                                SoftKeyExplanationView()
                                InfoText("Side soft keys are often used for programmable functions or speed dials in standby or one-touch menu selections in menus. For example, in a menu with 5 options, instead of scrolling up or down through the menu and then pressing the select button, you can press the corresponding side soft key.")
                            }
                        }
                        Picker("Button Backlight Type", selection: $phone.baseKeyBacklightAmount) {
                            Text("None").tag(0)
                            Text("Numbers Only").tag(1)
                            Text("Numbers + Some Function Buttons").tag(2)
                            Text("Numbers + All Function Buttons").tag(2)
                            Text("Numbers + Navigation Button").tag(3)
                            Text("All Buttons").tag(3)
                        }
                        if phone.baseKeyBacklightAmount > 0 {
                            ListColorPicker("Button Backlight Color", colors: Phone.backlightColors, selection: $phone.baseKeyBacklightColorName)
                        }
                        ListColorPicker("Button Foreground Color", colors: Phone.phoneColors, selection: $phone.baseKeyForegroundColorName)
                        ListColorPicker("Button Background Color", colors: Phone.phoneColors, selection: $phone.baseKeyBackgroundColorName)
                    }
                    Section(header: Text("Answering System/Voicemail")) {
                        Picker("Answering System", selection: $phone.hasAnsweringSystem) {
                            if phone.isCordless {
                                Text("None").tag(0)
                                Text("Base Only").tag(1)
                                Text("Handset Only").tag(2)
                                Text("Base or Handset").tag(3)
                            } else {
                                Text("No").tag(0)
                                Text("Yes").tag(1)
                            }
                        }
                        if !phone.isCordless && phone.hasAnsweringSystem == 1 {
                            Picker("Answering System Menu", selection: $phone.answeringSystemMenuOnBase) {
                                Text("Voice Prompts").tag(0)
                                if phone.baseDisplayType > 0 {
                                    Text("Display Menu").tag(1)
                                }
                            }
                        } else if phone.isCordless && (phone.hasAnsweringSystem == 1 || phone.hasAnsweringSystem == 3) {
                            Picker("Answering System Menu (base)", selection: $phone.answeringSystemMenuOnBase) {
                                Text("None").tag(0)
                                Text("Voice Prompts").tag(1)
                                if phone.baseDisplayType > 0 {
                                    Text("Display Menu").tag(2)
                                }
                            }
                        }
                        if phone.hasAnsweringSystem == 3 {
                            Picker("Greeting Management From", selection: $phone.greetingRecordingOnBaseOrHandset) {
                                Text("Base Only").tag(0)
                                Text("Handset Only").tag(1)
                                Text("Base or Handset").tag(2)
                            }
                            InfoText("The greeting, sometimes called the announcement or outgoing message, is the message the answering system plays to callers when it answers, before optionally allowing the caller to leave a message. Example: \"Hello. You have reached \(names.randomElement()!). I'm not available to take your call, so please leave a message after the tone.\"")
                        }
                        if phone.hasAnsweringSystem > 0 {
                            Toggle("Has Greeting Only Mode", isOn: $phone.hasGreetingOnlyMode)
                            InfoText("Greeting Only, sometimes called Announce Only or Answer Only, answers calls but doesn't accept incoming messages. Some phones allow you to record a separate greeting for both modes, allowing you to easily switch between modes without having to re-record your greeting each time. Example: \"Hello. You have reached \(names.randomElement()!). I'm not available to take your call, so please call again later.\"")
                            Toggle("Has Message Alert by Call", isOn: $phone.hasMessageAlertByCall)
                            InfoText("This feature allows the answering system to call out to a stored phone number each time a new message is left, so you don't have to constantly be calling to check for new messages while you're away.")
                        }
                        Picker("\"New Voicemail\" Detection Method", selection: $phone.voicemailIndication) {
                            Text("None").tag(0)
                            Text("Frequency-Shift-Keying (FSK) Tones").tag(1)
                            Text("Listen For Stutter Dial Tones").tag(2)
                            Text("FSK and Stutter Dial Tone").tag(3)
                        }
                        InfoText("""
A phone's voicemail indicator usually works in one or both of the following ways:
• Your phone company may send special tones, called Frequency-Shift-Keying (FSK) tones to the phone whenever a new voicemail is left, and another when all new voicemails are played, to tell the phone to turn on or off its voicemail indicator. You can't hear these tones unless you use a device to listen in on the phone line without picking it up (e.g. a butt-set phone in monitor mode).
• The phone may go off-hook for a few seconds periodically, or when you hang up or it stops ringing, to listen for a stutter dial tone ("bee-bee-bee-beeeeeeeep") which your phone company may use as an audible indication of new voicemails.
""")
                        Picker("Voicemail Quick Dial", selection: $phone.voicemailQuickDial) {
                            Text("None").tag(0)
                            Text("Button").tag(1)
                            Text("Speed Dial 1").tag(2)
                            Text("Message Menu Item").tag(3)
                            Text("Main Menu Item").tag(4)
                            Text("Main Menu Item and Button").tag(5)
                        }
                        InfoText("You can store your voicemail access number (e.g. *99) into the phone and quickly dial it using a button or menu item.")
                        if phone.voicemailQuickDial > 0 {
                            Toggle("Can Store Voicemail Feature Codes", isOn: $phone.voicemailFeatureCodes)
                            InfoText("Storing voicemail feature codes allows you to, for example, play and delete messages using a button or menu item once you've dialed into voicemail, just like with built-in answering systems. Example: If your voicemail system's main menu asks you to press 1 to play messages, you can store \"1\" to the Play code and then quickly dial it using a button/menu item.")
                        }
                    }
                    Section(header: Text("Audio Devices (e.g. headsets)")) {
                        if !phone.isCordless || phone.hasBaseSpeakerphone {
                            Toggle("Base Supports Wired Headsets", isOn: $phone.baseSupportsWiredHeadsets)
                        }
                        Picker("Maximum Number Of Bluetooth Headphones (base)", selection: $phone.baseBluetoothHeadphonesSupported) {
                            Text("None").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("4").tag(4)
                        }
                    }
                }
                Section(header: Text("Landline")) {
                    Picker("Number Of Lines", selection: $phone.numberOfLandlines) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("4").tag(4)
                    }
                    InfoText("On a 2- or 4-line phone, you can either plug each line into a separate jack, or use a single jack for 2 lines. For example, to plug a 2-line phone into a single 2-line jack, you would plug into the line 1/2 jack, or to plug into 2 single-line jacks, you would plug into both the line 1 and line 2 jacks. To use the one-jack-for-both-lines method, you need to make sure the phone cord has 4 copper contacts instead of just 2. With some phones, the included line cords are color-coded so you can easily tell which line they're for (e.g. black for line 1 and green for line 2).")
                    if phone.isCordless || phone.cordedPhoneType == 0 {
                        Picker("Landline In Use Status On Base", selection: $phone.landlineInUseStatusOnBase) {
                            Text("None").tag(0)
                            Text("Light").tag(1)
                            if phone.baseDisplayType > 1 {
                                Text("Display").tag(2)
                                Text("Display and Light").tag(3)
                            }
                        }
                        if phone.landlineInUseStatusOnBase == 1 {
                            Toggle("Landline In Use Light Follows Ring Signal", isOn: $phone.landlineInUseVisualRingerFollowsRingSignal)
                            InfoText("An in use light that follows the ring signal starts flashing when the ring signal starts and stops flashing when the ring signal stops. An in use light that ignores the ring signal starts flashing when the ring signal starts and continues flashing for as long as the base is indicating an incoming call.")
                        }
                    }
                }
                if phone.isCordless || phone.cordedPhoneType == 0 {
                    Section(header: Text("Cell Phone Linking")) {
                        Picker("Maximum Number Of Bluetooth Cell Phones", selection: $phone.baseBluetoothCellPhonesSupported) {
                            Text("None/Phonebook Transfers Only").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("4").tag(4)
                            Text("5").tag(5)
                            Text("10").tag(10)
                            Text("15").tag(15)
                        }
                        InfoText("Pairing a cell phone to the base via Bluetooth allows you to make and receive cell calls on the base or handsets and transfer your cell phone contacts to the phonebook.")
                        Picker("Maximum Number Of Smartphones As Handsets", selection: $phone.smartphonesAsHandsetsOverWiFi) {
                            Text("None").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("4").tag(4)
                        }
                        InfoText("When a smartphone is registered to a Wi-Fi-compatible base and both devices are on the same network, the smartphone can be used as a handset, and you can transfer its data to the base or handsets.")
                        if phone.baseBluetoothCellPhonesSupported > 0 {
                            Picker("Cell Line In Use Status On Base", selection: $phone.cellLineInUseStatusOnBase) {
                                Text("None").tag(0)
                                Text("Light").tag(1)
                                if phone.baseDisplayType > 1 {
                                    Text("Display and Light").tag(2)
                                }
                            }
                            Picker("Cell Line Only Behavior", selection: $phone.cellLineOnlyBehavior) {
                                Text("Optional \"No Line\" Alert").tag(0)
                                Text("Auto-Suppressed \"No Line\" Alert").tag(1)
                                Text("Cell Line Only Mode").tag(2)
                            }
                            InfoText("If you use only cell lines, the \"no line\" alert will be suppressed automatically or can be supressed manually, depending on the phone. A dedicated cell line only mode allows the phone to disable most landline-related features.")
                            Toggle("Has Cell Phone Voice Control", isOn: $phone.hasCellPhoneVoiceControl)
                            InfoText("You can talk to your cell phone voice assistant (e.g. Siri or Google Now) using the base or handset.")
                        }
                    }
                }
                Group {
                    if phone.hasBaseSpeakerphone || !phone.isCordless || phone.isCordedCordless {
                        Section(header: Text("Redial")) {
                            FormNumericTextField(phone.isCordless ? "Redial Capacity (base)" : "Redial Capacity", value: $phone.baseRedialCapacity)
#if !os(visionOS)
                                .scrollDismissesKeyboard(.interactively)
#endif
                            if phone.baseRedialCapacity > 1 && phone.basePhonebookCapacity > 0 {
                                Picker("Redial Name Display", selection: $phone.redialNameDisplay) {
                                    Text("None").tag(0)
                                    Text("Phonebook Match").tag(1)
                                    Text("From Dialed Entry").tag(2)
                                }
                            }
                        }
                    }
                    if phone.isCordless || phone.cordedPhoneType == 0 {
                        Section(header: Text("Phonebook")) {
                            FormNumericTextField(phone.isCordless ? "Phonebook Capacity (base)" : "Phonebook Capacity", value: $phone.basePhonebookCapacity)
#if !os(visionOS)
                                .scrollDismissesKeyboard(.interactively)
#endif
                            if phone.callBlockPreScreening > 0 {
                                InfoText("Numbers saved to the base's home phonebook will always ring through. Save frequently-dialed numbers you want to always ring through to the phonebook instead of the allowed numbers list.")
                            }
                            if phone.basePhonebookCapacity > 0 && phone.baseDisplayType > 0 {
                                Toggle(isOn: $phone.hasTalkingPhonebook) {
                                    Text("Talking Phonebook")
                                }
                                InfoText("The phone can announce the names of phonebook entries as you scroll through them.")
                            }
                            if phone.basePhonebookCapacity > 100 {
                                Picker("Bluetooth Phonebook Transfers", selection: $phone.bluetoothPhonebookTransfers) {
                                    if phone.baseBluetoothCellPhonesSupported == 0 {
                                        Text("Not Supported").tag(0)
                                    }
                                    Text("To Home Phonebook").tag(1)
                                    Text("To Separate Cell Phonebook").tag(2)
                                }
                                InfoText("Storing transferred cell phonebooks in the home phonebook allows those entries to work with features such as home line caller ID phonebook match and call block pre-screening. It also allows you to view all your phonebook entries in one place. If transferred cell phonebooks are stored separately from the home phonebook, caller ID phonebook match usually only works with the corresponding cell line.")
                                    .onChange(of: phone.baseBluetoothCellPhonesSupported) {
                                        newValue, oldValue in
                                        phone.baseBluetoothCellPhonesSupportedChanged(oldValue: oldValue, newValue: newValue)
                                    }
                            }
                        }
                    }
                    if phone.isCordless || phone.cordedPhoneType == 0 || phone.cordedPhoneType == 2 {
                        Section(header: Text("Caller ID")) {
                            if phone.basePhonebookCapacity > 0 {
                                Toggle(isOn: $phone.callerIDPhonebookMatch) {
                                    Text("Caller ID Name Uses Matching Phonebook Entry Name")
                                }
                            }
                            Toggle(isOn: $phone.hasTalkingCallerID) {
                                Text("Talking Caller ID")
                            }
                            InfoText("The phone can announce who's calling after each ring, so you don't have to look at the screen. Example: \"Call from \(names.randomElement()!)\".")
                            FormNumericTextField(phone.isCordless ? "Caller ID List Capacity (base)" : "Caller ID List Capacity", value: $phone.baseCallerIDCapacity)
#if !os(visionOS)
                                .scrollDismissesKeyboard(.interactively)
#endif
                        }
                        Section(header: Text("Speed Dial"), footer: Text(
   """
   Speed dial is usually used by holding down the desired number key or by pressing a button (usually called "Auto") followed by the desired number key. One-touch/memory dial is when the phone has dedicated speed dial buttons which either start dialing immediately when pressed, or which display/announce the stored number which can be dialed by then going off-hook. Some phones tie the one-touch/memory dial buttons to the first few speed dial locations (e.g. a phone with 10 speed dials (1-9 and 0) and memory dial A-C might use memory dial A-C as a quicker way to dial the number in speed dial 1-3.
   
   The speed dial entry mode describes how phonebook entries are saved to speed dial locations and whether they allow numbers to be manually entered. "Copy" means the phonebook entry will be copied to the speed dial location, and editing the phonebook entry won't affect the speed dial entry. "Link" means the speed dial entry is tied to the corresponding phonebook entry, so editing the phonebook entry will affect the speed dial entry and vice versa, and the speed dial entry will be deleted if the corresponding phonebook entry is deleted.
   
   By assigning a handset number to a cordless phone base's one-touch dial button, you can press it to quickly intercom/transfer a call to that handset.
   """)) {
       Stepper(phone.isCordless ? "Dial-Key Speed Dial Capacity (base): \(phone.baseSpeedDialCapacity)" : "Dial-Key Speed Dial Capacity: \(phone.baseSpeedDialCapacity)", value: $phone.baseSpeedDialCapacity, in: 0...50)
       if phone.baseSpeedDialCapacity > 10 {
           InfoText("Speed dial \(phone.baseSpeedDialCapacity > 11 ? "locations 11-\(phone.baseSpeedDialCapacity) are" : "location 11 is") accessed by pressing the speed dial button and then entering/scrolling to the desired location number.")
       }
       Stepper(phone.isCordless ? "One-Touch/Memory Dial (base): \(phone.baseOneTouchDialCapacity)" : "One-Touch Dial: \(phone.baseOneTouchDialCapacity)", value: $phone.baseOneTouchDialCapacity, in: 0...20)
       if phone.isCordless && phone.baseOneTouchDialCapacity > 0 {
           Toggle("Base One-Touch/Memory Dial Supports Handset Numbers", isOn: $phone.oneTouchDialSupportsHandsetNumbers)
       }
       if (phone.basePhonebookCapacity > 0 && (phone.baseSpeedDialCapacity > 0 || phone.baseOneTouchDialCapacity > 0)) {
           Picker("Speed Dial Entry Mode", selection: $phone.speedDialPhonebookEntryMode) {
               Text("Manual or Phonebook (copy)").tag(0)
               Text("Phonebook Only (copy)").tag(1)
               Text("Phonebook Only (link)").tag(2)
           }
       }
   }
                    }
                    if phone.isCordless || phone.cordedPhoneType == 0 {
                        Section(header: Text("Call Block (manual)")) {
                            FormNumericTextField("Call Block List Capacity", value: $phone.callBlockCapacity)
#if !os(visionOS)
                                .scrollDismissesKeyboard(.interactively)
#endif
                            if phone.callBlockCapacity > 0 {
                                Toggle(isOn: $phone.callBlockSupportsPrefixes) {
                                    Text("Can Block Number Prefixes")
                                }
                                InfoText("When a number prefix (e.g. an area code) is stored in the call block list, all numbers beginning with that prefix are blocked.")
                                if phone.callBlockPreScreening == 0 {
                                    Toggle(isOn: $phone.hasFirstRingSuppression) {
                                        Text("Has First Ring Suppression")
                                    }
                                    InfoText("""
Suppressing the first ring means the phone won't ring:
• Until allowed caller ID is received.
• At all for calls from blocked numbers.
When the first ring is suppressed, the number of rings you hear will be one less than the number of rings of the answering system/voicemail service.
""")
                                }
                                Picker("Blocked Callers Hear", selection: $phone.blockedCallersHear) {
                                    Text("Silence").tag(0)
                                    Text("Busy Tone (custom)").tag(1)
                                    Text("Busy Tone (traditional)").tag(2)
                                    Text("Voice Prompt").tag(3)
                                }
                                InfoText("Silence can make callers think your number is broken, making them unlikely to try calling you again.\nA custom busy tone is often the same one used for the intercom busy tone on \(phone.brand)'s cordless phones.\nA traditional busy tone is that of one of the countries where the phone is sold.")
                                Toggle(isOn: $phone.hasOneTouchCallBlock) {
                                    Text("Has One-Touch Call Block")
                                }
                            }
                            FormNumericTextField("Pre-Programmed Call Block Database Entry Count", value: $phone.callBlockPreProgrammedDatabaseEntryCount)
#if !os(visionOS)
                                .scrollDismissesKeyboard(.interactively)
#endif
                            if phone.callBlockPreProgrammedDatabaseEntryCount > 0 {
                                InfoText("Numbers in the pre-programmed call block database are not visible to the user and might be excluded from the caller ID list. Numbers from this database can be saved to the phonebook if they happen to become safe in the future.")
                            }
                        }
                        Section(header: Text("Call Block (pre-screening)"), footer: Text("Call block pre-screening asks callers to press a key so the phone can identify whether they're a human or a robot.\nCallers with numbers stored in the phone's allowed number list/database or phonebook, or callers whose caller ID names are stored in the phone's allowed name list, will always ring through.\nAsking for the caller name allows you to hear the caller's real name in their own voice when you pick up\(phone.hasTalkingCallerID ? " or as the caller ID announcement" : String()).")) {
                            Picker("Mode", selection: $phone.callBlockPreScreening) {
                                Text("Not Supported").tag(0)
                                Text("Caller Name").tag(1)
                                Text("Code").tag(2)
                            }
                            if phone.callBlockPreScreening > 0 {
                                InfoText("Example screening message: \"Hello. Your call is being screened to make sure you're a person. Please \(phone.callBlockPreScreening == 2 ? "press \(Int.random(in: 0...999))" : "say your name after the tone then press the pound key") to be connected.\"")
                                if phone.hasAnsweringSystem == 0 {
                                    InfoText("Calls can't go to a voicemail service once answered by a call block pre-screening system.")
                                }
                                Toggle("Supports Custom Greeting", isOn: $phone.callBlockPreScreeningCustomGreeting)
                                FormNumericTextField("Allowed Numbers Capacity", value: $phone.callBlockPreScreeningAllowedNumberCapacity)
#if !os(visionOS)
                                    .scrollDismissesKeyboard(.interactively)
#endif
                                Toggle("Allowed Numbers List Visible To User", isOn: $phone.callBlockPreScreeningAllowedNumberListVisible)
                                InfoText("Numbers saved to the allowed numbers list will always ring through.")
                                FormNumericTextField("Allowed Names Capacity", value: $phone.callBlockPreScreeningAllowedNameCapacity)
                                InfoText("If you don't know a caller's phone number, saving their name as it appears in the incoming caller ID will allow their calls to always ring through. This is a good place to put names of businesses you want to receive automated messages from (e.g. schools, doctor's offices, pharmacies).")
#if !os(visionOS)
                                    .scrollDismissesKeyboard(.interactively)
#endif
                            }
                        }
                        Section(header: Text("Special Features")) {
                            if phone.baseCallerIDCapacity > 0 || !phone.cordlessHandsetsIHave.filter({$0.callerIDCapacity > 0}).isEmpty {
                                Toggle("One-Ring Scam Call Detection", isOn: $phone.scamCallDetection)
                                InfoText("If a caller hangs up within 1 or 2 rings and caller ID is received, the phone can mark the call as a one-ring scam call when viewed in the caller ID list, and warn the user when trying to call that caller.")
                            }
                            Picker("Room/Baby Monitor", selection: $phone.roomMonitor) {
                                Text("Not Supported").tag(0)
                                Text("Call From Handset/Base").tag(1)
                                Text("Call To Handset/Base").tag(2)
                                Text("Sound-Activated Call").tag(3)
                            }
                            InfoText("Call From: You call the monitored handset/base.\nCall To: The monitored handset/base calls you at another handset/base.\nSound-Activated Call To: The monitored handset/base calls you at another handset/base or an outside phone number when sound is detected (e.g., a crying baby or barking dog).")
                            if phone.roomMonitor == 3 {
                                Picker("External Room Monitor Keypad Entry Handled By", selection: $phone.externalRoomMonitorAutomatedSystem) {
                                    Text("Base").tag(0)
                                    Text("Handset").tag(1)
                                }
                                InfoText("When a handset/base detects sound and calls an outside phone number, the outside caller can talk back to the handset/base by dialing a code, or deactivate the feature by dialing another code.")
                            }
                            Stepper("Smart Home Devices Supported: \(phone.smartHomeDevicesSupported)", value: $phone.smartHomeDevicesSupported, in: 0...50, step: 5)
                            InfoText("Smart home devices registered to a cordless phone can notify the handset/base or outside phone when things happen and the handset/base can control these devices. For example, when a person rings a doorbell, the phone can sound a chime and color display handsets can show a live feed of the doorbell's video.")
                            Toggle("Answer By Voice", isOn: $phone.answerByVoice)
                            InfoText("The base and compatible handsets can detect sound when landline/cell calls come in, allowing calls to be answered by voice. The phone either listens for any sound or is programmed to listen for a specific phrase.")
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .toggleStyle(.automaticPicker(labelPair: .yesNo))
#if !os(macOS)
            .pickerStyle(.navigationLink)
#endif
        }
        .photosPicker(isPresented: $photoViewModel.showingPhotoPicker, selection: $photoViewModel.selectedPhoto, matching: .images, preferredItemEncoding: .automatic)
        .onChange(of: photoViewModel.selectedPhoto, { oldValue, newValue in
            photoViewModel.updatePhonePhoto(for: phone, oldValue: oldValue, newValue: newValue)
        })
        .sheet(isPresented: $showingFrequenciesExplanation) {
            FrequenciesExplanationView()
        }
        .sheet(isPresented: $showingPhoneTypeDefinitions) {
            PhoneTypeDefinitionsView()
        }
#if os(iOS)
        .sheet(isPresented: $photoViewModel.takingPhoto) {
            CameraViewController(viewModel: photoViewModel, phone: phone)
        }
#endif
        .alert(isPresented: $photoViewModel.showingPhonePhotoErrorAlert, error: photoViewModel.phonePhotoError) {
            Button("OK") {
                photoViewModel.showingPhonePhotoErrorAlert = false
                photoViewModel.phonePhotoError = nil
            }
            .keyboardShortcut(.defaultAction)
        }
#if os(macOS)
        .dialogSeverity(.critical)
#endif
        .alert("Reset photo?", isPresented: $photoViewModel.showingResetAlert) {
            Button(role: .destructive) {
                phone.photoData = nil
                photoViewModel.showingResetAlert = false
            } label: {
                Text("Delete")
            }
            Button(role: .cancel) {
                photoViewModel.showingResetAlert = false
            } label: {
                Text("Cancel")
            }
        }
        .alert("Selected photo doesn't appear to contain landline phones. Save anyway?", isPresented: $photoViewModel.showingUnsurePhotoDataAlert) {
            Button {
                phone.photoData = photoViewModel.unsurePhotoDataToUse
                photoViewModel.unsurePhotoDataToUse = nil
                photoViewModel.showingUnsurePhotoDataAlert = false
            } label: {
                Text("Save")
            }
            .keyboardShortcut(.defaultAction)
            Button(role: .cancel) {
                photoViewModel.showingUnsurePhotoDataAlert = false
            } label: {
                Text("Cancel")
            }
        }
    }
    
    // MARK: - Phone Photo/Actions
    
    @ViewBuilder
    func photo(for phone: Phone) -> some View {
        Group {
            HStack {
                Spacer()
                PhoneImage(phone: phone, thumb: false)
                Spacer()
            }
#if os(iOS)
            Button {
                photoViewModel.takingPhoto = true
            } label: {
                Text("Take Photo…")
            }
#endif
            Button {
                photoViewModel.showingPhotoPicker = true
            } label: {
                Text("Select From Library…")
            }
            Button {
                photoViewModel.showingResetAlert = true
            } label: {
                Text("Use Placeholder…")
            }
        }
    }
    
}

#Preview {
    PhoneDetailView(phone: Phone(brand: "AT&T", model: "CL83207"))
}
