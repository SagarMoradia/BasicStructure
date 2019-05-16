import Foundation
struct UserPlaylistModel : Codable {
	let meta : Model_Meta?
	let data : [PlaylistData]?
    let errors : Model_Errors?

	enum CodingKeys: String, CodingKey {

		case meta = "meta"
		case data = "data"
        case errors = "errors"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Model_Meta.self, forKey: .meta)
		data = try values.decodeIfPresent([PlaylistData].self, forKey: .data)
        errors = try values.decodeIfPresent(Model_Errors.self, forKey: .errors)
	}
}

struct PlaylistData : Codable {
    let uuid : String?
    let name : String?
    let privacy : String?
    
    enum CodingKeys: String, CodingKey {
        
        case uuid = "uuid"
        case name = "name"
        case privacy = "privacy"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
    }
    
}
