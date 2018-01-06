import UIKit

class ProductViewController: UIViewController {
    
    var product: Product?
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        let dataDecoded: Data = Data(base64Encoded: product!.image!.value!, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        picture.image = decodedimage
        self.navigationItem.title = product?.name
        
        priceLabel.text = "€ \(String(format:"%.2f", product!.price!))"
        descriptionLabel.text = product?.description
    }
    
    @IBAction func addToCart() {
        CartService.addToCart(product: product!)
        self.tabBarController?.viewControllers![1].tabBarItem.badgeValue = String(format: "%d", CartService.getTotalamount())
    }
}
