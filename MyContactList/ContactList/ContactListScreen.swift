import UIKit

protocol ContactListScreenProtocol: AnyObject {
    func tappedAddContactButton()
}

class ContactListScreen: UIView {
    
    var delegate: ContactListScreenProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 7
        tableView.backgroundColor = .systemGray .withAlphaComponent(1.6)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var addContactButton: UIButton = {
        let button = UIButton()
        button.setTitle("Adicionar Contato", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addContact), for: .touchUpInside)
        return button
    }()
    
    @objc func addContact() {
        delegate?.tappedAddContactButton()
    }
    
    func configTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    func setupComponents() {
        addSubview(tableView)
        addSubview(addContactButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addContactButton.topAnchor, constant: -5),
            
            addContactButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addContactButton.heightAnchor.constraint(equalToConstant: 45),
            addContactButton.widthAnchor.constraint(equalToConstant: 160),
            addContactButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
}
