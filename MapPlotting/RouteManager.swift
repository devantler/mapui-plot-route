import SwiftUI
import MapKit

public class RouteManager {
    public var rawRoute: [CLLocationCoordinate2D] = []
    public var meanRoute: [CLLocationCoordinate2D] = []
    public var medianRoute:[CLLocationCoordinate2D] = []
    
    init(){
        rawRoute = getRouteFromCsv()
        meanRoute = calculateMeanRoute()
        medianRoute = calculateMedianRoute()
    }
    
    private func getRouteFromCsv() -> Array<CLLocationCoordinate2D>{
        var parsedCSV: [[String]] = []
        var locations: [CLLocationCoordinate2D] = []
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
            locations.append(CLLocationCoordinate2D(latitude: Double(item[1])!, longitude: Double(item[2])!))
        }
        return locations
    }
    
    private func calculateMeanRoute() -> Array<CLLocationCoordinate2D>{
        var meanRoute:[CLLocationCoordinate2D] = []
        for (index, _) in rawRoute.enumerated() {
            var meanLat = 0.0
            var meanLong = 0.0
            let (first, last, interval) = (-3, 3, 1)
            var n = first
            for _ in stride(from: first, to: last, by: interval) {
                meanLat += rawRoute[(index+n+rawRoute.count) % rawRoute.count].latitude
                meanLong += rawRoute[(index+n+rawRoute.count) % rawRoute.count].longitude
                n += interval
            }
            meanLat /= Double((last-first))
            meanLong /= Double((last-first))
            meanRoute.append(CLLocationCoordinate2D(latitude: meanLat, longitude: meanLong))
        }
        return meanRoute
    }
    
    private func calculateMedianRoute() -> Array<CLLocationCoordinate2D>{
        var medianRoute:[CLLocationCoordinate2D] = []
        for (index, _) in rawRoute.enumerated() {
            var medianLatArray: [Double] = []
            var medianLongArray: [Double] = []
            let (first, last, interval) = (-3, 3, 1)
            var n = first
            for _ in stride(from: first, to: last, by: interval) {
                medianLatArray.append(rawRoute[(index+n+rawRoute.count) % rawRoute.count].latitude)
                medianLongArray.append(rawRoute[(index+n+rawRoute.count) % rawRoute.count].longitude)
                n += interval
            }
            medianLatArray.sort()
            medianLongArray.sort()
            let medianLat = medianLatArray[(last-first)/2]
            let medianLong = medianLongArray[(last-first)/2]
            medianRoute.append(CLLocationCoordinate2D(latitude: medianLat, longitude: medianLong))
        }
        return medianRoute
    }
}
