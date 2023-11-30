//
//  MapView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 11/27/23.
//

import Foundation
import SwiftUI
import MapKit


struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0219, longitude: -118.4814),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $region)
                    .ignoresSafeArea()

                DetailCardView()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
            }
            .navigationBarTitle("Locations", displayMode: .inline)
        }
    }
}

struct DetailCardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("The Bicycle Whisperer")
                        .font(.headline)
                    Text("Bike Sharing • 19 min")
                        .font(.subheadline)
                    RatingView(rating: 4.5, reviewCount: 373)
                }
                Spacer()
                VStack {
                    Button(action: {
                        // Directions action
                    }) {
                        Label("Directions", systemImage: "arrow.right.circle.fill")
                    }
                    Text("54 min drive")
                        .font(.footnote)
                }
            }
            
            Divider()
            
            HStack {
                ForEach(0..<3) { _ in
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipped()
                }
            }
            
            // Additional details...
        }
        .padding()
    }
}

struct RatingView: View {
    let rating: Double
    let reviewCount: Int
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text("\(rating, specifier: "%.1f") (\(reviewCount) on Yelp)")
                .font(.caption)
        }
    }
}

struct MapVoew_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}


