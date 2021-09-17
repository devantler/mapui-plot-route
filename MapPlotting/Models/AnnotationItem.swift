import MapKit
import SwiftUI

public struct AnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    var color: Color?
    var tint: Color { color ?? .red }
    public let id = UUID()
}
