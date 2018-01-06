import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categorytLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    var product: Product! {
        didSet {
            nameLabel.text = product.name
            priceLabel.text = "€ \(String(format:"%.2f", product.price!))"
            categorytLabel.text = product.category
            descriptionLabel.text = product.description
            
            /*if (product.image?) == nil else {
                
            } else*/ if product.image != nil {
                let dataDecoded: Data = Data(base64Encoded: product.image!.value!, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                picture.image = decodedimage
            }
        }
    }
}
