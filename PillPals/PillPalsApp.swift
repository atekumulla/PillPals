//
//  PillPalsApp.swift
//  PillPals
//
//  Created by anush on 11/19/23.
//

import SwiftUI

@main
struct PillPalsApp: App {
    var body: some Scene {
        WindowGroup {
            
            TabView() {
                UserProfileForm().tabItem() {
                    Label("Profile", systemImage: "person.circle")
                }
                CarouselView().tabItem() {
                    Image(systemName: "folder")
                }
            }
        }
    }
}
