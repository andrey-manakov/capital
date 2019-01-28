internal final class AccountGroupDetailVC: ViewController {
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        let service = Service()

        let table: SimpleTableProtocol = SimpleTable()
        if let data = data as? (id: String, name: String) {
            service.getData(withId: data.id) { dataModel in
                table.localData = dataModel
            }
            table.didSelect = {[unowned self] row, _ in
                let viewController = AccountTransactionsVC((row.texts[.id], row.texts[.name]))
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            title = data.name
            navigationItem.rightBarButtonItem = BarButtonItem(title: "Edit") {[unowned self] in
                let viewController = AccountGroupEditVC((data.id, data.name))
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
    }
}
/// Extension to provide view controller with service class
extension AccountGroupDetailVC {
    private class Service: ClassService {
        private var accounts = [String: Account]()

        func getData(withId id: String?, completion: @escaping ((DataModelProtocol) -> Void)) {
            guard let id = id else {
                return
            }
            data.setListnersToAccountsInGroup(withId: id, for: self.id) { data in
                for (id, account, changeType) in data {
                    switch changeType {
                    case .added, .modified:
                        self.accounts[id] = account

                    case .removed:
                        self.accounts.removeValue(forKey: id)
                    }
                }
                let rows = self.accounts.map {
                    DataModelRow(texts: [.id: $0.key, .name: $0.value.name ?? "", .desc: "\($0.value.amount ?? 0)"])
                }
//                let dataModel = DataModel(self.accounts.map {
//                    (id: $0.key, name: $0.value.name, desc: "\($0.value.amount ?? 0)")
//                })
                completion(DataModel(rows))
            }
        }

        func deleteAccountGroup(id: String) {
            data.deleteAccountGroup(withId: id, completion: nil)
        }
    }
}
