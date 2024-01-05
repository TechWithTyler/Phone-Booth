//
//  PhoneColorInfoView.swift
//  Phone Booth
//
//  Created by Tyler Sheft on 6/19/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import SwiftData
import SwiftUI
import SheftAppsStylishUI

struct PhonePartInfoView: View {
    
    // MARK: - Properties - Phone

	@Bindable var phone: Phone
    
    // MARK: - Body

	var body: some View {
		Section(phone.isCordless ? "Base Colors" : "Colors") {
            ListColorPicker("Base Main Color", colors: Phone.phoneColors, selection: $phone.baseMainColorName)
            HStack {
                ListColorPicker("Base Secondary/Accent Color", colors: Phone.phoneColors, selection: $phone.baseSecondaryColorName)
                Button("Use Main Color") {
                    phone.baseSecondaryColorName = phone.baseMainColorName
                }
            }
            InfoText("The main color is the top color of a base/charger or the front color of a handset. The secondary color is the color for the sides of a base/charger/handset and the back of a handset.\nSometimes, the base/charger/handset is all one color, with the secondary color used as an accent color in various places such as around the edges.")
            ListColorPicker("Corded Receiver Main Color (None if cordless-only)", colors: Phone.phoneColors, selection: $phone.cordedReceiverMainColorName, allowNoColor: true)
                .onChange(of: phone.cordedReceiverMainColorName) { oldValue, newValue in
                    phone.cordedReceiverColorChanged(oldValue: oldValue, newValue: newValue)
                }
            if phone.hasCordedReceiver {
                ListColorPicker("Corded Receiver Secondary/Accent Color", colors: Phone.phoneColors, selection: $phone.cordedReceiverSecondaryColorName)
            }
		}
		if phone.isCordless {
			Section("Cordless Handsets/Headsets/Speakerphones/Desksets") {
				if !phone.cordlessHandsetsIHave.isEmpty {
						ForEach($phone.cordlessHandsetsIHave) { handset in
							NavigationLink {
								HandsetInfoDetailView(handset: handset, handsetNumber: (phone.cordlessHandsetsIHave.firstIndex(of: handset.wrappedValue) ?? 0) + 1)
									.navigationTitle("Handset Details")
							} label: {
								VStack {
									Text("\(handset.wrappedValue.brand) \(handset.wrappedValue.model)")
									Text("Handset \((phone.cordlessHandsetsIHave.firstIndex(of: handset.wrappedValue) ?? 0) + 1)")
										.foregroundStyle(.secondary)
								}
							}
							.contextMenu {
								Button(role: .destructive) {
									deleteHandset(at: phone.cordlessHandsetsIHave.firstIndex(of: handset.wrappedValue)!)
								} label: {
									Text("Deregister")
								}
							}
							.swipeActions {
								Button(role: .destructive) {
									deleteHandset(at: phone.cordlessHandsetsIHave.firstIndex(of: handset.wrappedValue)!)
								} label: {
									Text("Deregister")
								}
							}
						}
				} else {
					Text("No handsets")
						.foregroundStyle(.secondary)
				}
				if phone.cordlessHandsetsIHave.count < phone.maxCordlessHandsets || phone.maxCordlessHandsets == -1 {
					Button(action: addHandset) {
						Label("Add", systemImage: "plus")
							.frame(width: 100, alignment: .leading)
					}
					.buttonStyle(.borderless)
					.accessibilityIdentifier("AddHandsetButton")
				} else if phone.cordlessHandsetsIHave.count > phone.maxCordlessHandsets {
					WarningText("You have more handsets than the base can handle!")
				}
				Button {
					phone.cordlessHandsetsIHave.removeAll()
					phone.chargersIHave.removeAll()
				} label: {
					Text("Deregister All")
				}
			}
			Section("Chargers") {
				if !phone.chargersIHave.isEmpty {
						ForEach($phone.chargersIHave) { charger in
							NavigationLink {
								ChargerInfoDetailView(charger: charger)
									.navigationTitle("Charger Details")
							} label: {
								VStack {
									Text("Charger \((phone.chargersIHave.firstIndex(of: charger.wrappedValue) ?? 0) + 1)")
								}
							}
								.contextMenu {
									Button(role: .destructive) {
										deleteCharger(at: phone.chargersIHave.firstIndex(of: charger.wrappedValue)!)
									} label: {
										Text("Delete")
									}
								}
								.swipeActions {
									Button(role: .destructive) {
										deleteCharger(at: phone.chargersIHave.firstIndex(of: charger.wrappedValue)!)
									} label: {
										Text("Delete")
									}
								}
						}
				} else {
					Text("No chargers")
						.foregroundStyle(.secondary)
				}
					Button(action: addCharger) {
						Label("Add", systemImage: "plus")
							.frame(width: 100, alignment: .leading)
					}
					.buttonStyle(.borderless)
					.accessibilityIdentifier("AddChargerButton")
			}
		}
	}
    
    // MARK: - Data Management

	func addHandset() {
		phone.cordlessHandsetsIHave.append(
			CordlessHandset(brand: phone.brand, model: "MH12")
		)
	}

	func addCharger() {
		phone.chargersIHave.append(Charger())
	}

	func deleteHandset(at index: Int) {
		phone.cordlessHandsetsIHave.remove(at: index)
	}

	func deleteCharger(at index: Int) {
		phone.chargersIHave.remove(at: index)
	}

}

#Preview {
	PhonePartInfoView(phone: Phone(brand: "Panasonic", model: "KX-TGD892"))
}
