//
//  MapView.swift
//  MapView
//
//  Created by Nikolai Emil Damm on 17/09/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.removeOverlays(view.overlays)
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        view.addOverlay(polyline)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemGreen
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
}
