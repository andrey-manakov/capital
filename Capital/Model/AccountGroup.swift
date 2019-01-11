// MARK: - Introduction of Account.Group class
extension Account {
    internal final class Group: DataObject, Equatable {
        // swiftlint:disable nesting
        /// Fields names
        ///
        /// - accounts: accounts field
        /// - name: name field
        /// - amount: amount field
        /// - min: amount and date of minimum value
        internal enum Fields: String {
            case accounts
            case name
            case amount
            case min
            // swiftlint:disable nesting
            internal enum Min: String {
                case amount, date
            }
        }

        internal var name: String?
        internal var amount: Int?
        internal var min: (amount: Int, date: Date)?
        internal var accounts: [AccountId: AccountName]?

        internal static func == (lhs: Account.Group, rhs: Account.Group) -> Bool {
            let currentDate = Date()
            let lhsmin = lhs.min ?? (amount: 0, date: currentDate)
            let rhsmin = rhs.min ?? (amount: 0, date: currentDate)
            return lhs.amount == rhs.amount &&
                lhs.accounts == rhs.accounts &&
                lhsmin.amount == rhsmin.amount &&
                rhsmin.date.isSameDate(lhsmin.date) &&
                lhs.name == rhs.name
        }

        internal required convenience init(_ data: [String: Any]) {
            self.init()
            for (field, value) in data {
                update(field: field, value: value)
            }
        }

        internal func update(field: String, value: Any) {
            guard let property = Account.Group.Fields(rawValue: field) else {
                return
            }
            switch property {
            case .name:
                self.name = value as? String

            case .amount:
                self.amount = value as? Int

            case .min:
                guard let value = value as? [String: Any],
                    let minAmount = value[Account.Fields.Min.amount.rawValue] as? Int,
                    let minDate = (value[Account.Fields.Min.date.rawValue] as? Timestamp)?.dateValue() else {
                        return
                }
                self.min = (amount: minAmount, date: minDate)

            case .accounts:
                self.accounts = value as? [String: String]
            }
        }

    }
}
