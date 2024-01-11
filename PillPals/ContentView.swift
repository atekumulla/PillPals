//
//  ContentView.swift
//  PillPals
//
//  Created by anush on 1/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            CaregiverView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Caregiver")
                }
            }
    }
}

#Preview {
    ContentView()
}
