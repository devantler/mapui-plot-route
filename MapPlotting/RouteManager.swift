import SwiftUI
import MapKit

public class RouteManager {
    public var rawRoute: [AnnotationItem] = []
    public var meanRoute: [AnnotationItem] = []
    public var medianRoute:[AnnotationItem] = []
    
    init(){
        rawRoute = getRouteFromCsv()
        meanRoute = calculateMeanRoute()
        medianRoute = calculateMedianRoute()
    }
    
    private func getRouteFromCsv() -> Array<AnnotationItem>{
        var parsedCSV: [[String]] = []
        var locations: [AnnotationItem] = []
        do {
            let path = Bundle.main.url(forResource: "Running", withExtension: "csv")?.path
            let content = try String(contentsOfFile: path!)
            parsedCSV = content.components(
                separatedBy: "\n"
            ).map{
                $0.components(separatedBy: ",")
            }
        }
        catch {
            return locations
        }
        for (index, item) in parsedCSV.enumerated() {
            if(index == 0 || index == (parsedCSV.count - 1)){
                continue
            }
            locations.append(AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: Double(item[1])!, longitude: Double(item[2])!), color: .yellow))
        }
        return locations
    }
    
    private func calculateMeanRoute() -> Array<AnnotationItem>{
        var meanRoute:[AnnotationItem] = []
        for (index, _) in rawRoute.enumerated() {
            var meanLat = 0.0
            var meanLong = 0.0
            let (first, last, interval) = (-4, 4, 1)
            var n = first
            for _ in stride(from: first, to: last, by: interval) {
                meanLat += rawRoute[(index+n+rawRoute.count) % rawRoute.count].coordinate.latitude
                meanLong += rawRoute[(index+n+rawRoute.count) % rawRoute.count].coordinate.longitude
                n += interval
            }
            meanLat /= Double((last-first))
            meanLong /= Double((last-first))
            meanRoute.append(AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: meanLat, longitude: meanLong), color: .orange))
        }
        return meanRoute
    }
    
    private func calculateMedianRoute() -> Array<AnnotationItem>{
        var medianRoute:[AnnotationItem] = []
        for (index, _) in rawRoute.enumerated() {
            var medianLatArray: [Double] = []
            var medianLongArray: [Double] = []
            let (first, last, interval) = (-3, 3, 1)
            var n = first
            for _ in stride(from: first, to: last, by: interval) {
                medianLatArray.append(rawRoute[(index+n+rawRoute.count) % rawRoute.count].coordinate.latitude)
                medianLongArray.append(rawRoute[(index+n+rawRoute.count) % rawRoute.count].coordinate.longitude)
                n += interval
            }
            medianLatArray.sort()
            medianLongArray.sort()
            let medianLat = medianLatArray[(last-first)/2]
            let medianLong = medianLongArray[(last-first)/2]
            medianRoute.append(AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: medianLat, longitude: medianLong), color: .red))
        }
        return medianRoute
    }
}
