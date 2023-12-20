//
//  DisplayTodoCell.swift
//  RxSwift


import UIKit

class DisplayTodoCell: UITableViewCell {

    @IBOutlet weak var discriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.cornerRadius = 5.0 // Optional: Add corner radius for rounded corners
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
