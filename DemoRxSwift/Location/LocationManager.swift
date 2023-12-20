//
//  LocationManager.swift
//  DemoRxSwift


import Foundation
import CoreLocation
import RxCocoa
import RxSwift
// Location Provider Protocol
// Location Provider Protocol
protocol LocationProvider: AnyObject {
    var locationUpdate: Observable<CLLocation> { get }
    func startUpdatingLocation()
}

// Location Manager
class LocationManager: NSObject, CLLocationManagerDelegate, LocationProvider {
    static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    private let locationSubject = PublishSubject<CLLocation>()

    var locationUpdate: Observable<CLLocation> {
        return locationSubject.asObservable()
    }

    private override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate method to handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationSubject.onNext(location)
    }
}
