//
//  ChargerInfoDetailView.swift
//  Phone Booth
//
//  Created by Tyler Sheft on 8/16/23.
//  Copyright © 2023 SheftApps. All rights reserved.
//

import SwiftUI
import SheftAppsStylishUI

struct ChargerInfoDetailView: View {

	@Binding var charger: Charger

	var body: some View {
		if let phone = charger.phone {
			Form {
				Section {
					FormTextField("Color", text: $charger.color)
					Picker("Charge Contact Placement", selection: $charger.chargeContactPlacement) {
						Text("Bottom").tag(0)
						Text("Back").tag(1)
						Text("One On Each Side").tag(2)
					}
					Picker("Charge Contact Mechanism", selection: $charger.chargeContactMechanism) {
						Text("Press Down").tag(0)
						Text("Click").tag(1)
						Text("Inductive").tag(2)
					}
					ChargingContactInfoView()
					Picker("Wall Mounting", selection: $charger.chargeContactMechanism) {
						Text("Not Supported").tag(0)
						Text("Holes On Back").tag(1)
						Text("Bracket").tag(2)
					}
					if phone.supportsRangeExtenders {
						Toggle("Has Range Extender", isOn: $charger.hasRangeExtender)
						HStack {
							Image(systemName: "info.circle")
							Text("A charger with a built-in range extender allows you to have a range extender where you have a charger, without having to register and place a separate range extender.")
						}
							.font(.footnote)
							.foregroundStyle(.secondary)
					}
				}
			}
			.formStyle(.grouped)
#if os(macOS)
			.toggleStyle(.checkbox)
#else
			.toggleStyle(.switch)
#endif
		} else {
			Text("Error")
		}
	}
}

//#Preview {
//	ChargerInfoDetailView(charger: <#Binding<Charger>#>)
//}
