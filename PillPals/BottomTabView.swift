//
//  BottomTabView.swift
//  PillPals
//
//  Created by anush on 11/29/23.
//

// USELESS CODE RN

import SwiftUI

struct BottomTabView: View {
    var body: some View {
        TabView {
            CaregiverView()
               .tabItem {
                   Image(systemName: "person")
                   Text("Caregiver")
               }
            
            
        }
        .padding()
    }
}


//NavigationLink(destination: CaregiverView()) {
//    
//}
//.tabItem {
//    Image(systemName: "person")
//    Text("Caregiver")
//}
//
//NavigationLink(destination: ContentView()) {]}
//.tabItem {
//    Image(systemName: "house")
//    Text("Home")
//}
