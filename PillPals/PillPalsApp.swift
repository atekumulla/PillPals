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
                HomeView().tabItem() {
                    Label("Home", systemImage: "house.fill")
                }
                UserProfileForm().tabItem() {
                    Label("Profile", systemImage: "person.circle")
                }
                /*CarouselView().tabItem() {
                    Image(systemName: "folder")
                }*/
            }
        }
    }
}
