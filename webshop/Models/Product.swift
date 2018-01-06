import ObjectMapper

class Product: Mappable {
    
    public var _id: String?
    public var name: String?
    public var description: String?
    public var category: String?
    public var price: Double?
    public var image: Image?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id         <- map["_id"]
        name        <- map["name"]
        description <- map["description"]
        category    <- map["category"]
        price       <- map["price"]
        image       <- map["image"]
    }
}

extension Product: Hashable {
    var hashValue: Int {
        return (_id?.hashValue)!
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs._id == rhs._id
    }
}
