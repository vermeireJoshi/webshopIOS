import UIKit

class RegisterController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    var username: String?
    
    @IBAction func register() {
        if usernameTextField.text != "" &&
            passwordTextField.text != "" &&
            repeatPasswordTextField.text != "" &&
            passwordTextField.text == repeatPasswordTextField.text {
            
            UserService.register(username: usernameTextField.text!, password: passwordTextField.text!,
                succes: {(
                    self.username = self.usernameTextField.text,
                    self.performSegue(withIdentifier: "didRegister", sender: self)
                )}, failure: { (response) -> Void in (
                    self.createAlert(message: response as! String)
                )})
        } else {
            self.createAlert(message: "All fields are required.")
        }
    }
    
    @IBAction func cancel() {
        self.performSegue(withIdentifier: "didNotRegister", sender: self)
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

