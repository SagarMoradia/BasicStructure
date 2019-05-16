import Foundation
struct ReportCategoryModel : Codable {
	let meta : Model_Meta?
	let data : [ReportCategoryData]?
    let errors : Model_Errors?

	enum CodingKeys: String, CodingKey {

		case meta = "meta"
		case data = "data"
        case errors = "errors"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Model_Meta.self, forKey: .meta)
		data = try values.decodeIfPresent([ReportCategoryData].self, forKey: .data)
        errors = try values.decodeIfPresent(Model_Errors.self, forKey: .errors)
	}
}

struct ReportCategoryData : Codable {
    let uuid : String?
    let title : String?
    
    enum CodingKeys: String, CodingKey {
        
        case uuid = "uuid"
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
    
}
