import Foundation

struct Model_Meta : Codable {
    let status : Bool?
    let message : String?
    let message_code : String?
    let status_code : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case message_code = "message_code"
        case status_code = "status_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        message_code = try values.decodeIfPresent(String.self, forKey: .message_code)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
    }
}

struct Model_Errors : Codable {
    
    let device_type : [String]?
    let email : [String]?
    let phone_number : [String]?
    let name : [String]?
    let uuid : [String]?
    let user_uuid : [String]?
    let story_uuid : [String]?
    let latitude : [String]?
    let longitude : [String]?
    let rating : [String]?
    let current_date : [String]?
    //For Tweak
    let title : [String]?
    let category : [String]?
    let module : [String]?
    let status : [String]?
    //For Wallet
    let user_id : [String]?
    let sort_param : [String]?
    let sort_type : [String]?
    let lock_unlock : [String]?
    let pin : [String]?
    let question_id : [String]?
    let answer : [String]?
    
    //product
    let expiry_dt : [String]?
    let mrp : [String]?
    let contact_no : [String]?
    let categories : [String]?
    
    
//    (["is_chat_on": "1", "expiry_dt": "31/ 12 /2018", "email": "kushal@gmail.com", "mrp": "2.20", "description": "Fgdgdfgdfgfdg", "contact_no": "+91 9343432345", "pro_type": "Barter", "location": "Mumbai", "categories": "", "title": "JBL Wireless Bluetooth Speaker", "user_id": "41", "user_type": "User", "points": "800"])
    
    
    enum CodingKeys: String, CodingKey {
        
        case device_type = "device_type"
        case email = "email"
        case phone_number = "phone_number"
        case name = "name"
        case uuid = "uuid"
        case user_uuid = "user_uuid"
        case story_uuid = "story_uuid"
        case latitude = "latitude"
        case longitude = "longitude"
        case rating = "rating"
        case current_date = "current_date"
        //For Tweak
        case title = "title"
        case category = "category"
        case module = "module"
        case status = "status"
        //For Wallet
        case user_id = "user_id"
        case sort_param = "sort_param"
        case sort_type = "sort_type"
        case lock_unlock = "lock_unlock"
        case pin = "pin"
        case question_id = "question_id"
        case answer = "answer"
        //product
        case expiry_dt = "expiry_dt"
        case mrp = "mrp"
        case contact_no = "contact_no"
        case categories = "categories"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        device_type = try values.decodeIfPresent([String].self, forKey: .device_type)
        email = try values.decodeIfPresent([String].self, forKey: .email)
        phone_number = try values.decodeIfPresent([String].self, forKey: .phone_number)
        name = try values.decodeIfPresent([String].self, forKey: .name)
        uuid = try values.decodeIfPresent([String].self, forKey: .uuid)
        user_uuid = try values.decodeIfPresent([String].self, forKey: .user_uuid)
        story_uuid = try values.decodeIfPresent([String].self, forKey: .story_uuid)
        latitude = try values.decodeIfPresent([String].self, forKey: .latitude)
        longitude = try values.decodeIfPresent([String].self, forKey: .longitude)
        rating = try values.decodeIfPresent([String].self, forKey: .rating)
        current_date = try values.decodeIfPresent([String].self, forKey: .current_date)
        //For Tweak
        title = try values.decodeIfPresent([String].self, forKey: .title)
        category = try values.decodeIfPresent([String].self, forKey: .category)
        module = try values.decodeIfPresent([String].self, forKey: .module)
        status = try values.decodeIfPresent([String].self, forKey: .status)
        //For Wallet
        user_id = try values.decodeIfPresent([String].self, forKey: .user_id)
        sort_param = try values.decodeIfPresent([String].self, forKey: .sort_param)
        sort_type  = try values.decodeIfPresent([String].self, forKey: .sort_type)
        lock_unlock  = try values.decodeIfPresent([String].self, forKey: .lock_unlock)
        pin  = try values.decodeIfPresent([String].self, forKey: .pin)
        question_id = try values.decodeIfPresent([String].self, forKey: .question_id)
        answer = try values.decodeIfPresent([String].self, forKey: .answer)
        //product
        expiry_dt = try values.decodeIfPresent([String].self, forKey: .expiry_dt)
        mrp = try values.decodeIfPresent([String].self, forKey: .mrp)
        contact_no = try values.decodeIfPresent([String].self, forKey: .contact_no)
        categories = try values.decodeIfPresent([String].self, forKey: .categories)
    }
}

class Model_Settings : Codable {
    var code : String?
    var isEmailVerificationRequired : String?
    var message : String?
    
    enum CodingKeys: String, CodingKey {
        
        case code = "code"
        case message = "message"
        case isEmailVerificationRequired = "isEmailVerificationRequired"
    }
    
    init() {
        code = nil
        isEmailVerificationRequired = nil
        message = nil
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        isEmailVerificationRequired = try values.decodeIfPresent(String.self, forKey: .isEmailVerificationRequired)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

