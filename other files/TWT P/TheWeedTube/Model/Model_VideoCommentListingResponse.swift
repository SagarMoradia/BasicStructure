import Foundation
struct Model_VideoCommentListingResponse : Codable {
	let meta : Model_Meta?
	let data : Model_CommentListingData_Level1?
    let errors : Model_Errors?

	enum CodingKeys: String, CodingKey {

		case meta = "meta"
		case data = "data"
        case errors = "errors"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Model_Meta.self, forKey: .meta)
		data = try values.decodeIfPresent(Model_CommentListingData_Level1.self, forKey: .data)
        errors = try values.decodeIfPresent(Model_Errors.self, forKey: .errors)
	}
}

struct Model_CommentListingData_Level1 : Codable {
    //let headers : Headers?
    let original : Model_Original_CommentList?
    //let exception : String?
    
    enum CodingKeys: String, CodingKey {
        
        //case headers = "headers"
        case original = "original"
        //case exception = "exception"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        //headers = try values.decodeIfPresent(Headers.self, forKey: .headers)
        original = try values.decodeIfPresent(Model_Original_CommentList.self, forKey: .original)
        //exception = try values.decodeIfPresent(String.self, forKey: .exception)
    }
}

struct Model_Original_CommentList : Codable {
    let draw : Int?
    let recordsTotal : Int?
    let recordsFiltered : Int?
    let data : [Model_CommentListingData]?
    
    enum CodingKeys: String, CodingKey {
        
        case draw = "draw"
        case recordsTotal = "recordsTotal"
        case recordsFiltered = "recordsFiltered"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        draw = try values.decodeIfPresent(Int.self, forKey: .draw)
        recordsTotal = try values.decodeIfPresent(Int.self, forKey: .recordsTotal)
        recordsFiltered = try values.decodeIfPresent(Int.self, forKey: .recordsFiltered)
        data = try values.decodeIfPresent([Model_CommentListingData].self, forKey: .data)
    }
    
}

class Model_CommentListingData : Codable {
    var comment : String?
    let created_at : String?
    var comment_uuid : String?
    var like_count : String?
    var dislike_count : String?
    let user_name : String?
    
    let user_username : String?
    
    let u_id : String?
    let user_uuid : String?
    let profile_image : String?
    let srNum : String?
    let profile_photo : String?
    var is_like : String?
    var reply_count : String?
    var reply_uuid : String?
    
    enum CodingKeys: String, CodingKey {
        
        case comment = "comment"
        case created_at = "created_at"
        case comment_uuid = "comment_uuid"
        case like_count = "like_count"
        case dislike_count = "dislike_count"
        case user_name = "user_name"
        case u_id = "u_id"
        case user_uuid = "user_uuid"
        case profile_image = "profile_image"
        case srNum = "srNum"
        case profile_photo = "profile_photo"
        case is_like = "is_like"
        case reply_count = "reply_count"
        case reply_uuid = "reply_uuid"
        
        case user_username = "user_username"
        
        
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        comment_uuid = try values.decodeIfPresent(String.self, forKey: .comment_uuid)
        like_count = try values.decodeIfPresent(String.self, forKey: .like_count)
        dislike_count = try values.decodeIfPresent(String.self, forKey: .dislike_count)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        u_id = try values.decodeIfPresent(String.self, forKey: .u_id)
        user_uuid = try values.decodeIfPresent(String.self, forKey: .user_uuid)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
        srNum = try values.decodeIfPresent(String.self, forKey: .srNum)
        profile_photo = try values.decodeIfPresent(String.self, forKey: .profile_photo)
        is_like = try values.decodeIfPresent(String.self, forKey: .is_like)
        reply_count = try values.decodeIfPresent(String.self, forKey: .reply_count)
        reply_uuid = try values.decodeIfPresent(String.self, forKey: .reply_uuid)
        
        user_username = try values.decodeIfPresent(String.self, forKey: .user_username)
        
        
        
    }
    
}
