//
//  TodoViewController.swift
//  DemoRxSwift


import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import FirebaseCrashlytics

class TodoViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    //MARK: Variables
    var username: String?
    private let todoViewModel = TodoItemViewModel()
    private let disposeBag = DisposeBag()
    private let locationManager = LocationManager.shared
    private let weatherViewModel = WeatherViewModel()
    private var hourlyTemperatureData: [String] = []
    private var hourlyTimeData: [String] = []
    var alertController = UIAlertController()
    //MARK: View Load Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Crashlytics.crashlytics().log("TodoViewController: viewDidLoad() called")
        setupUI()
        setupBindings()
        self.weatherViewModel.fetchWeather(latitude: 37.785834, longitude: -122.406417)
    }
    //MARK: Setup View & Bindings
    //Configure UI
    private func setupUI() {
        tableView.delegate = self
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //Setup Bindings here
    private func setupBindings() {
        // Bind todoItems to tableView
        todoViewModel.todoItems
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "todoItemsList", cellType: DisplayTodoCell.self)) { index, item, cell in
                // Assuming TodoItemEntity has 'title', 'description', and 'dateTime' properties
                if let title = item.title {
                    cell.titleLbl.text = "\(title)"
                }
                if let dateTime = item.dateTime {
                    cell.dateTimeLbl.text = "\(dateTime)"
                }
                if let discription = item.discription {
                    cell.discriptionLbl.text = "\(discription)"
                }
            }
            .disposed(by: disposeBag)
        
        // Bind addButton tap to show alert for adding a new item
        addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showAddItemAlert()
            })
            .disposed(by: disposeBag)
        
        
        locationManager.locationUpdate
            .subscribe(onNext: { [weak self]location in
                // Handle the received location
                Crashlytics.crashlytics().log("location data received successfully")
                print("Received location update: \(location)")
                self?.weatherViewModel.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            })
            .disposed(by: disposeBag)
        
        // Bind weather data and errors to update UI
        weatherViewModel.weatherData
            .observe(on: MainScheduler.instance) // UI updates are on the main thread
            .subscribe(onNext: { [weak self] weatherData in
                Crashlytics.crashlytics().log("Weather data received successfully")
                // Update UI with weather data
                guard let weatherData  = weatherData  else {return}
                self?.initializeTempratureAndHoursData(weatherData)
                self?.collectionView.reloadData() // Reload the collectionView when weather data is updated
            })
            .disposed(by: disposeBag)
        
        todoViewModel.setLoggedInUsername(username ?? "")
        
    }
    //MARK: Alerts
    private func showAddItemAlert() {
        AlertHelper.showAddItemAlert(in: self) { [weak self] title, description, date in
            self?.todoViewModel.addTodoItem(title: title, descriptionText: description, dateTime: date)
        }
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.alertController.textFields?.last?.text = dateFormatter.string(from: sender.date)
    }
    
    private func initializeTempratureAndHoursData(_ weatherData: WeatherData) {
        hourlyTemperatureData = weatherData.hourly.temperature2M.map { "\(Int($0)) °C" }
        hourlyTimeData = weatherData.hourly.time.map { "\($0)"}
    }
    
}
//MARK: Extensions : Table Delegate
extension TodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Implement edit functionality here
        showEditItemAlert(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Implement delete functionality here
        if editingStyle == .delete {
            todoViewModel.deleteTodoItem(at: indexPath.row)
        }
    }
}
//MARK: Extensions : Collection Delegate
extension TodoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyTemperatureData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let temperature = hourlyTemperatureData[indexPath.item]
        let time = DateFormatterHelper.shared.formatTime(from: hourlyTimeData[indexPath.item]) ?? "00:00 AM"
        
        cell.configure(time: time, temperature: temperature)
        return cell
    }
}

extension TodoViewController {
    private func showEditItemAlert(at index: Int) {
        AlertHelper.showEditItemAlert(in: self, title: todoViewModel.todoItems.value[index].title ?? "N/A", description: todoViewModel.todoItems.value[index].discription, dateTime: todoViewModel.todoItems.value[index].dateTime) { [weak self] title, description, date in
            self?.todoViewModel.updateTodoItem(at: index, withTitle: title, descriptionText: description, dateTime: date)
        }
    }
}

