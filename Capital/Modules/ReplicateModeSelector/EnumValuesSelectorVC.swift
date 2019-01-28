internal final class EnumValuesSelectorVC: ViewController {
    internal var table: SimpleTableProtocol = SimpleTable()
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        guard let dataV = data as? (sourceData: () -> (DataModel), selectionAction: (Any?) -> Void) else {
            return
        }
        table.dataFormula = dataV.sourceData
        table.didSelect = {[unowned self] row, _ in
            dataV.selectionAction(row.texts[.id])
            self.dismiss()
        }
    }
}
