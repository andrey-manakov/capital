/// Parent to all "service" classes which accompany View Controllers
internal class ClassService {
    internal let data: DataProtocol
    internal var id: ObjectIdentifier { return ObjectIdentifier(self) }

    internal init(_ data: DataProtocol = Data.shared) {
        if (UIApplication.shared.delegate as? AppDelegate)?.testing ?? false {
            self.data = Data.sharedForUnitTests
        } else {
            self.data = data
        }
    }
    deinit {
        /// Check that View Controller is deallocated - for debug purposes
        print("\(type(of: self)) deinit")
        /// Removes from the listeners list
        data.removeListners(ofObject: self.id)
    }
}
