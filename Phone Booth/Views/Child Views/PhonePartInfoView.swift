//
//  PhoneColorInfoView.swift
//  Phone Booth
//
//  Created by Tyler Sheft on 6/19/23.
//

import SwiftData
import SwiftUI

struct PhonePartInfoView: View {

	@Bindable var phone: Phone

	var body: some View {
		Section(phone.isCordless ? "Base Colors" : "Colors") {
			TextField("Base Color", text: $phone.baseColor)
			TextField("Corded Receiver Color", text: $phone.cordedReceiverColor)
				.onChange(of: phone.cordedReceiverColor) { oldValue, newValue in
					phone.cordedReceiverColorChanged(oldValue: oldValue, newValue: newValue)
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
								Button {
									deleteHandset(at: phone.cordlessHandsetsIHave.firstIndex(of: handset.wrappedValue)!)
								} label: {
									Text("Delete")
								}
							}
						}
						.onDelete(perform: deleteItemsFromHandsetList(offsets:))
				} else {
					Text("No handsets")
						.foregroundStyle(.secondary)
				}
				if phone.cordlessHandsetsIHave.count < phone.maxCordlessHandsets {
					Button(action: addHandset) {
						Label("Add", systemImage: "plus")
							.frame(width: 100, alignment: .leading)
					}
					.buttonStyle(.borderless)
					.accessibilityIdentifier("AddHandsetButton")
				} else if phone.cordlessHandsetsIHave.count > phone.maxCordlessHandsets {
					HStack {
						Image(systemName: "exclamationmark.triangle")
							.symbolRenderingMode(.multicolor)
						Text("You have more handsets than the base can handle!")
					}
					.font(.callout)
					.foregroundStyle(.secondary)
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
									Button {
										deleteCharger(at: phone.chargersIHave.firstIndex(of: charger.wrappedValue)!)
									} label: {
										Text("Delete")
									}
								}
						}
						.onDelete(perform: deleteItemsFromChargerList(offsets:))
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

	func addHandset() {
		DispatchQueue.main.async { [self] in
			phone.cordlessHandsetsIHave.append(
				CordlessHandset(brand: phone.brand, model: "MH12")
			)
		}
	}

	func addCharger() {
		DispatchQueue.main.async { [self] in
		phone.chargersIHave.append(Charger())
		}
	}

	private func deleteItemsFromHandsetList(offsets: IndexSet) {
		DispatchQueue.main.async { [self] in
			withAnimation {
				for index in offsets {
					deleteHandset(at: index)
				}
			}
		}
	}

	func deleteHandset(at index: Int) {
		DispatchQueue.main.async { [self] in
			phone.cordlessHandsetsIHave.remove(at: index)
		}
	}

	private func deleteItemsFromChargerList(offsets: IndexSet) {
		DispatchQueue.main.async { [self] in
		withAnimation {
				for index in offsets {
					deleteCharger(at: index)
				}
			}
		}
	}

	func deleteCharger(at index: Int) {
		DispatchQueue.main.async { [self] in
			phone.chargersIHave.remove(at: index)
		}
	}

}

#Preview {
	PhonePartInfoView(phone: Phone(brand: "Panasonic", model: "KX-TGD892"))
}