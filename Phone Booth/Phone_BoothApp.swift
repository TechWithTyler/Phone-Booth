//
//  Phone_BoothApp.swift
//  Phone Booth
//
//  Created by Tyler Sheft on 6/15/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import SwiftUI
import SwiftData

@main
struct Phone_BoothApp: App {
    
    @ObservedObject var photoViewModel = PhonePhotoViewModel()

    var body: some Scene {
		DocumentGroup(editing: Phone.self, contentType: .phoneBoothDatabase) {
            ContentView()
                .environmentObject(photoViewModel)
        }
    }
    
    init() {
        ValueTransformer.setValueTransformer(Color.NamedColorTransformer(), forName:NSValueTransformerName("NamedColorTransformer"))

    }
}
