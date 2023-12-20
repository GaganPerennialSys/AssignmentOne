//
//  WeatherViewModel.swift
//  DemoRxSwift


import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class WeatherViewModel {
    private let disposeBag = DisposeBag()
    private let locationManager: LocationProvider

    // Outputs
    
    let weatherData: BehaviorRelay<WeatherData?> = BehaviorRelay(value: nil)
    
    let error: PublishRelay<Error> = PublishRelay()

    init(locationManager: LocationProvider = LocationManager.shared) {
        self.locationManager = locationManager
        bindLocationUpdates()
    }

    private func bindLocationUpdates() {
        locationManager.locationUpdate
            .subscribe(onNext: { [weak self] location in
                self?.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            })
            .disposed(by: disposeBag)

        locationManager.startUpdatingLocation()
    }

    func fetchWeather(latitude: Double, longitude: Double) {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m") else {
            return
        }

        URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data -> WeatherData in
                let decoder = JSONDecoder()
                return try decoder.decode(WeatherData.self, from: data)
            }
            .subscribe(onNext: { [weak self] weatherData in
                self?.weatherData.accept(weatherData)
            }, onError: { [weak self] error in
                self?.error.accept(error)
            })
            .disposed(by: disposeBag)
    }
}
