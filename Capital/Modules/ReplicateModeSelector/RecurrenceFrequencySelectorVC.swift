internal final class RecurrenceFrequencySelectorVC: ViewController {
    override internal func viewDidLoad() {
        super.viewDidLoad()
        let table: SimpleTableProtocol = SimpleTable()
        table.dataFormula = {
            DataModel(RecurrenceFrequency.allCases.map { (id: "\($0.rawValue)", name: $0.name) })
        }
        view.add(subView: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        let selectionAction = data as? ((Any?) -> Void)
        table.didSelect = {[unowned self] row, _ in
            selectionAction?(row.id)
            self.dismiss()
        }
    }
}
