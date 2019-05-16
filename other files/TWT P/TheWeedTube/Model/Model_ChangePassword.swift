

import Foundation
class Model_ChangePasswordResponce : Codable {
    var meta : Model_Meta?
//    var data : Model_Settings?
    var errors : Model_Errors?
    
    enum CodingKeys: String, CodingKey {
        
        case meta = "meta"
//        case data = "data"
        case errors = "errors"
    }
    
    init() {
        meta = nil
//        data = nil
        errors = nil
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        meta = try values.decodeIfPresent(Model_Meta.self, forKey: .meta)
//        data = try values.decodeIfPresent(Model_Settings.self, forKey: .data)
        errors = try values.decodeIfPresent(Model_Errors.self, forKey: .errors)
    }
    
}
