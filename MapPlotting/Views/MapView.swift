//
//  MapView.swift
//  MapView
//
//  Created by Nikolai Emil Damm on 17/09/2021.
//

import SwiftUI
import CoreLocationUI
import MapKit

struct MapView: View {
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: MapDefaults.latitude, longitude: MapDefaults.longitude),
        span: MKCoordinateSpan(latitudeDelta: MapDefaults.zoom, longitudeDelta: MapDefaults.zoom))
    
    private var routeManager = RouteManager()
    
    @State private var annotationItems: [AnnotationItem] = []
    
    private enum MapDefaults {
        static let latitude = 56.131
        static let longitude = 10.199
        static let zoom = 0.03
    }
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region,
                interactionModes: .all,
                annotationItems: annotationItems) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    Image(systemName: "circle.fill").resizable().frame(width: 10, height: 10)
                        .foregroundColor(item.tint)
                }
            }
            HStack{
                Button(action: {
                    annotationItems = routeManager.rawRoute
                }) {
                    Text("Raw Route")
                        .foregroundColor(.white)
                        .font(.body)
                        .padding(10)
                }.background(Color.yellow).cornerRadius(40)
                
                Button(action: {
                    annotationItems = routeManager.meanRoute
                }) {
                    Text("Mean Route")
                        .foregroundColor(.white)
                        .font(.body)
                        .padding(10)
                }.background(Color.orange).cornerRadius(40)
                
                Button(action: {
                    annotationItems = routeManager.medianRoute
                }) {
                    Text("Median Route")
                        .foregroundColor(.white)
                        .font(.body)
                        .padding(10)
                }.background(Color.red).cornerRadius(40)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
