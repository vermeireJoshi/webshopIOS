import UIKit

class BasketCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var product: Product! {
        didSet {
            nameLabel.text = product.name
            priceLabel.text = "€ \(String(format: "%.2f", product.price!))"
        }
    }
    
    var amount: Int! {
        didSet {
            amountLabel.text = "\(String(format: "%d", amount))x"
        }
    }
}
