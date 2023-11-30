//
//  BottomTabView.swift
//  PillPals
//
//  Created by anush on 11/29/23.
//

import SwiftUI

struct BottomTabView: View {
    var body: some View {
        TabView {
            NavigationLink(destination: CaregiverView()) {
                Image(systemName: "person")
                Text("Caregiver")
            }
            .tabItem {
                Image(systemName: "person")
                Text("Caregiver")
            }

            NavigationLink(destination: ContentView()) {
                Image(systemName: "house")
                Text("Home")
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
        }
        .padding()
    }
}
