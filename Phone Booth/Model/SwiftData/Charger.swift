//
//  Charger.swift
//  Phone Booth
//
//  Created by Tyler Sheft on 6/28/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import SheftAppsStylishUI
import SwiftUI
import SwiftData

@Model
final class Charger {
    
    // MARK: - Properties

	var phone: Phone?
    
    var id = UUID()
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var mainColorName: Color.Named
    
    @Attribute(.transformable(by: Color.NamedColorTransformer.self)) var secondaryColorName: Color.Named

	var chargingDirection: Int = 0

	var chargeContactPlacement: Int = 0

	var chargeContactMechanism: Int = 1

	var hasRangeExtender: Bool = false

	var wallMountability: Int = 0
    
    // MARK: - Initialization

	init() {
        self.mainColorName = .black
        self.secondaryColorName = .black
	}
    
    // MARK: - Set Secondary Color to Main
    
    func setSecondaryColorToMain() {
        secondaryColorName = mainColorName
    }

}
