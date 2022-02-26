
extension Array {
    func any(_ index: Index) -> Element? {
        self.indices.contains(index) ? self[index] : nil
    }
}
