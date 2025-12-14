struct List: Codable {
    var name: String
    var price: Double

    var formattedPrice: String {
        String(format: "%.2f", price)
    }
}
