import ObjectMapper

class Location: Mappable {
    
    public var name: String?
    public var location: String?
    public var latitude: Double?
    public var longitude: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        location    <- map["location"]
        latitude    <- map["latitude"]
        longitude   <- map["longitude"]
    }
}

