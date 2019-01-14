internal final class AccountTransactionsVC: ViewController {
    override internal func viewDidLoad() {
        super.viewDidLoad()
        let data = self.data as? AccountInfo
        let id = data?.id
        title = data?.name
        let table: TransactionsTableProtocol = TransactionsTable()
        let service = AccountTransactionsVC.Service()
        service.getData(withId: id) { dataModel in table.localData = dataModel }

        navigationItem.rightBarButtonItem = BarButtonItem(title: "Edit") {
            self.navigationController?.pushViewController(AccountDetailVC(id), animated: true)
        }

        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])

        // MARK: transaction table setup
        table.swipeLeftAction = {
            row in service.deleteTransaction(withId: row?.texts[.id])
        }
        table.swipeLeftLabel = "Delete"
        table.swipeRightAction = {
            row in service.deleteTransaction(withId: row?.texts[.id])
        }
        table.swipeRightLabel = "Approve"
    }
}

extension AccountTransactionsVC {
    private class Service: ClassService {
        private var transactions = [String: FinTransaction]()

        func getData(withId id: String?, completion: @escaping ((DataModelProtocol) -> Void)) {
            guard let id = id else {
                return
            }
            data.setListnersToTransactionsOfAccount(withId: id, for: self.id) {[unowned self] data in
                for (id, transaction, changeType) in data {
                    switch changeType {
                    case .added, .modified:
                        self.transactions[id] = transaction

                    case .removed:
                        self.transactions.removeValue(forKey: id)
                    }
                }
                let rows: [DataModelRowProtocol] = self.transactions.map {
                    DataModelRow(texts:
                        [
                        .id: $0.key,
                        .left: $0.value.dateText,
                        .up: $0.value.from?.name ?? "",
                        .down: $0.value.to?.name ?? "",
                        .right: "\($0.value.amount ?? 0)"
                        ])
//                    DataModelRow(id: $0.key, left: $0.value.dateText, up: $0.value.from?.name, down: $0.value.to?.name, right: "\($0.value.amount ?? 0)")
                }
                completion(DataModel(rows))
//                completion(DataModel(self.transactions.map {(
//                    id: $0.key,
//                    left: $0.value.dateText,
//                    up: $0.value.from?.name,
//                    down: $0.value.to?.name,
//                    right: "\($0.value.amount ?? 0)")
//                }))
            }
        }

        func deleteTransaction(withId id: String?, completion: (() -> Void)? = nil) {
            // FIXME: Add implementation
        }

        func approveTransaction(withId id: String?, completion: (() -> Void)? = nil) {
            // FIXME: Add implementation
        }
    }
}
