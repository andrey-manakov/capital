internal protocol SettingsServiceProtocol: class {
    var view: SettingsViewControllerProtocol? { get set }

    func viewDidLoad(_ view: SettingsViewControllerProtocol)
    func didSelect(_ row: DataModelRowProtocol, at indexPath: IndexPath)
}

// TODO: Consider moving inside Settings View Controller
internal final class SettingsService: ClassService, SettingsServiceProtocol {
    weak internal var view: SettingsViewControllerProtocol?

    internal func viewDidLoad(_ view: SettingsViewControllerProtocol) {
        self.view = view
        getData()
    }

    internal func getData() {
        view?.table.localData = DataModel(Settings.allCases.map {
            (id: "\($0.rawValue)", name: $0.name, desc: "")
        })
    }

    internal func didSelect(_ row: DataModelRowProtocol, at indexPath: IndexPath) {
        guard let id = row.id, let idInt = Int(id), let settings = Settings(rawValue: idInt) else {
            return
        }
        switch settings {
        case .logOut:
            data.signOut { error in
                if let error = error {
                    print("Error in loggin out user \(error.localizedDescription)")
                } else {
                    self.view?.dismissNavigationViewController()
                }
            }
        case .deleteUser:
            data.deleteUser { error in
                if let error = error {
                    print("Error in deleting user \(error.localizedDescription)")
                } else {
                    self.view?.dismissNavigationViewController()
                }
            }
        }
    }

    internal enum Settings: Int, CaseIterable {
        case logOut, deleteUser

        internal var name: String {
            switch self {
            case .logOut:
                return "Log Out"
            case .deleteUser:
                return "Delete User"
            }
        }
    }

}
