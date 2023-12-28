import UIKit

class AlertHelper {
    static func displayAlertToAddContact(on viewController: UIViewController, completion: @escaping (String, String, String) -> Void) {
        let alertController = UIAlertController(title: "Adicionar Contato", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Nome"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Telefone"
            textField.keyboardType = .phonePad
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "E-mail"
            textField.keyboardType = .emailAddress
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        let saveAction = UIAlertAction(title: "Salvar", style: .default) { _ in
            guard let nameField = alertController.textFields?[0],
                  let phoneField = alertController.textFields?[1],
                  let emailField = alertController.textFields?[2],
                  let name = nameField.text,
                  let phone = phoneField.text,
                  let email = emailField.text else { return }
            
            completion(name, phone, email)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        viewController.present(alertController, animated: true)
    }
}

