//
//  ContentView.swift
//  MapPlotting
//
//  Created by Nikolai Emil Damm on 17/09/2021.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        // Apple Park
        center: CLLocationCoordinate2D(latitude: MapDefaults.latitude, longitude: MapDefaults.longitude),
        span: MKCoordinateSpan(latitudeDelta: MapDefaults.zoom, longitudeDelta: MapDefaults.zoom)
    )
    
    private enum MapDefaults {
        static let latitude = 56.131
        static let longitude = 10.199
        static let zoom = 0.03
    }
    
    private var routeManager = RouteManager()
    
    @State private var lineCoordinates: [CLLocationCoordinate2D] = []
    
    var body: some View {
        MapView(
            region: region,
            lineCoordinates: lineCoordinates
        )
            .edgesIgnoringSafeArea(.all)
        HStack{
            Button(action: {
                lineCoordinates = routeManager.rawRoute
            }) {
                Text("Raw Route")
                    .foregroundColor(.white)
                    .font(.body)
                    .padding(10)
            }.background(Color.blue).cornerRadius(40)
            
            Button(action: {
                lineCoordinates = routeManager.meanRoute
            }) {
                Text("Mean Route")
                    .foregroundColor(.white)
                    .font(.body)
                    .padding(10)
            }.background(Color.purple).cornerRadius(40)
            
            Button(action: {
                lineCoordinates = routeManager.medianRoute
            }) {
                Text("Median Route")
                    .foregroundColor(.white)
                    .font(.body)
                    .padding(10)
            }.background(Color.green).cornerRadius(40)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
