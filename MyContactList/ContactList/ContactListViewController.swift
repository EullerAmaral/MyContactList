import UIKit

class ContactListViewController: UIViewController {

    var contactListScreen: ContactListScreen?
    var contact: [Contact] = []
    
    override func loadView() {
        contactListScreen = ContactListScreen()
        view = contactListScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
        contactListScreen?.delegate = self
        contactListScreen?.configTableViewProtocols(delegate: self, dataSource: self)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Meus contatos"
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.backButtonTitle = "Voltar"
        }
    
    @objc private func addContact() {
        AlertHelper.displayAlertToAddContact(on: self) { name, phone, email in
            let newContact = Contact(name: name, phone: phone, email: email)
            self.contact.append(newContact)
            self.saveContacts()
            self.contactListScreen?.tableView.reloadData()
        }
    }
    
    private func loadContacts() {
        if let savedData = UserDefaults.standard.data(forKey: "contacts"),
           let decodedContacts = try? JSONDecoder().decode([Contact].self, from: savedData) {
            contact = decodedContacts
            contactListScreen?.tableView.reloadData()
        }
    }
    
    private func saveContacts() {
        if let encodedData = try? JSONEncoder().encode(contact) {
            UserDefaults.standard.set(encodedData, forKey: "contacts")
        }
    }
}

extension ContactListViewController: ContactListScreenProtocol {
    func tappedAddContactButton() {
        AlertHelper.displayAlertToAddContact(on: self) { name, phone, email in
            let newContact = Contact(name: name, phone: phone, email: email)
            self.contact.append(newContact)
            self.saveContacts()
            self.contactListScreen?.tableView.reloadData()
        }
    }
}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contact = contact[indexPath.row]
        cell.textLabel?.text = "\(contact.name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedContact = contact[indexPath.row]
        showContactDetails(contact: selectedContact)
    }
    
    private func showContactDetails(contact: Contact) {
        let detailsVC = ContactDetailsViewController()
        detailsVC.contact = contact
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Excluir") { [weak self] (_, _, completion) in
            self?.contact.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        deleteAction.backgroundColor = .red
    
        let editAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] (_, _, completionHandler) in
            self?.editContact(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    private func editContact(at indexPath: IndexPath) {
        let selectedContact = contact[indexPath.row]
        
        AlertHelper.displayAlertToAddContact(on: self) { [weak self] name, phone, email in
            var updatedContact = selectedContact
            updatedContact.name = name
            updatedContact.phone = phone
            updatedContact.email = email
            
            self?.contact[indexPath.row] = updatedContact
            self?.saveContacts()
            self?.contactListScreen?.tableView.reloadData()
        }
    }
}
