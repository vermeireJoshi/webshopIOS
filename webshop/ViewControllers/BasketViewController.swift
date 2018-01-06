import UIKit

class BasketViewController: UIViewController {
    
    @IBOutlet weak var basketItems: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    var keys: [Product]!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
    }
    
    private func viewLoadSetup(){
        keys = CartService.getKeys()
        
        if keys.isEmpty {
            orderButton.isEnabled = false
            totalPriceLabel.text = "No items in basket"
        } else {
            orderButton.isEnabled = true
            totalPriceLabel.text = "€ \(String(format: "%.2f", CartService.getTotalPrice()))"
        }
        
        basketItems.reloadData()
    }
    
    @IBAction func order() {
        if UserService.getUserInfo().0 == "" {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            CartService.order(succes: {(
                self.createAlert(positive: true, message: "Order completed"),
                self.viewLoadSetup()
            )}, failure: { (response) in
                self.createAlert(positive: false, message: response as! String)
            })
        }
    }
    
    @IBAction func unwindFromLogin(_ segue: UIStoryboardSegue) {
        switch(segue.identifier!) {
        case "didLogin":
            CartService.order(succes: {
                self.createAlert(positive: true, message: "Order completed")
                self.viewLoadSetup()
                self.tabBarController?.viewControllers![1].tabBarItem.badgeValue = String(format: "%d", CartService.getTotalamount())
            }, failure: { (response) in
                self.createAlert(positive: false, message: response as! String)
            })
        case "didNotLogin":
            print("Did not login")
        default:
            fatalError("Unknown segue")
        }
    }
    
    func createAlert(positive: Bool, message: String) {
        var alert: UIAlertController
        if positive {
            alert = UIAlertController(title: "Succesfull", message: message, preferredStyle: UIAlertControllerStyle.alert)
        } else {
            alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            CartService.removeProduct(product: self.keys[indexPath.row])
            self.keys = CartService.getKeys()
            
            if self.keys.isEmpty {
                self.orderButton.isEnabled = false
                self.totalPriceLabel.text = "No items in basket"
            } else {
                self.totalPriceLabel.text = "€ \(String(format: "%.2f", CartService.getTotalPrice()))"
            }
            
            self.tabBarController?.viewControllers![1].tabBarItem.badgeValue = String(format: "%d", CartService.getTotalamount())
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension BasketViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath) as! BasketCell
        cell.product = keys[indexPath.row]
        cell.amount = CartService.getAmount(product: keys[indexPath.row])
        return cell
    }
}
