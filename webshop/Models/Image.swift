import ObjectMapper

class Image: Mappable {
    
    public var name: String?
    public var type: String?
    public var value: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name    <- map["filename"]
        type    <- map["filetype"]
        value   <- map["value"]
    }
}
