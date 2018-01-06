import UIKit

class ProductListController: UITableViewController {
    
    @IBOutlet weak var productsView: UITableView!

    var products = [Product]()
    var indexPathToEdit: IndexPath!
    let pullToRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.getProducts(succes: { (response) -> Void in (
            self.products = response,
            self.productsView.reloadData()
            )}, failure: { (response) -> Void in self.createAlert(message: response as! String) })
        
        pullToRefreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        pullToRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        productsView.refreshControl = pullToRefreshControl
    }
    
    @objc private func refresh(_ sender: Any) {
        loadTable(succes: { (response) -> Void in (
            self.products = response,
            self.productsView.reloadData(),
            self.pullToRefreshControl.endRefreshing()
        )}, failure: { (response) -> Void in (
            self.createAlert(message: response as! String),
            self.pullToRefreshControl.endRefreshing()
        )})
    }
    
    func loadTable(succes: @escaping (_ response: [Product]) -> Void, failure: @escaping (_ error: Any) -> Void) {
        APIService.getProducts(succes: succes, failure: failure)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showProductDetail"?:
            let productViewController = segue.destination as! ProductViewController
            productViewController.product = products[indexPathToEdit.row]
        default:
            fatalError("Unknown segue")
        }
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Tablieview Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
        cell.product = products[indexPath.row]
        return cell
    }
    
    // Tableview Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPathToEdit = indexPath
        self.performSegue(withIdentifier: "showProductDetail", sender: self)
    }
}
