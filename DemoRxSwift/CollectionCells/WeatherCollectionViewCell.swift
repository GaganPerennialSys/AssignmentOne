//
//  WeatherCollectionViewCell.swift
//  DemoRxSwift
//

import Foundation
import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 2.0 // Optional: Add corner radius for rounded corners
    }


    func configure(time: String, temperature: String) {
      
        timeLabel.text = time
        temperatureLabel.text = temperature
    }
}
