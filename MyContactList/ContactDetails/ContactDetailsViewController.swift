import UIKit

class ContactDetailsViewController: UIViewController {
    
    var contact: Contact?
    var contactDetailsScreen: ContactDetailsScreen?
    
    override func loadView() {
        contactDetailsScreen = ContactDetailsScreen()
        view = contactDetailsScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTitle()
        displayContactDetails()
    }
    
    func configTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Contato"
    }
    
    private func displayContactDetails() {
        guard let contact = contact else { return }
        contactDetailsScreen?.nameLabel.text = "Nome: \(contact.name)"
        contactDetailsScreen?.phoneLabel.text = "Telefone: \(contact.phone)"
        contactDetailsScreen?.emailLabel.text = "Email: \(contact.email)"
    }
}
