import Foundation
import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet var restaurantLabel: UILabel!
    @IBOutlet var mealAmountTextLabel: UILabel! {didSet{mealAmountTextLabel.localized()}}
    @IBOutlet var mealAmountLabel: UILabel!
    @IBOutlet var timesTextLabel: UILabel! {didSet{timesTextLabel.localized()}}
    @IBOutlet var timesLabel: UILabel!
    @IBOutlet var orderNumberTextLabel: UILabel! {didSet{orderNumberTextLabel.localized()}}
    @IBOutlet var orderNumberLabel: UILabel!
    
    func configure(order: Order) {
        restaurantLabel.text = order.restaurantName
        mealAmountLabel.text = String(order.dishesAmount ?? 0)
        timesLabel.text = order.pickupTime
        orderNumberLabel.text = order.number
    }
}
