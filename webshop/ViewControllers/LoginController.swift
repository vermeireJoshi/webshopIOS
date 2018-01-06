import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func login() {
        if usernameTextField.text != "" && passwordTextField.text != "" {
            UserService.login(username: usernameTextField.text!, password: passwordTextField.text!, succes: {(
                    self.performSegue(withIdentifier: "didLogin", sender: self)
                )}, failure: { (response) -> Void in (
                    self.createAlert(message: response as! String)
                )})
        } else {
            self.createAlert(message: "Username and password are required")
        }
    }
    
    @IBAction func cancel() {
        self.performSegue(withIdentifier: "didNotLogin", sender: self)
    }
    
    @IBAction func unwindFromRegister(_ segue: UIStoryboardSegue) {
        switch (segue.identifier!) {
        case "didRegister":
            let registerController = segue.source as! RegisterController
            usernameTextField.text = registerController.username!
            print("Did register")
        case "didNotRegister":
            print("Did not register")
        default:
            fatalError("Unknown segue")
        }
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
