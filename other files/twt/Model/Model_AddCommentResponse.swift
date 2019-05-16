
import Foundation

struct Model_AddCommentResponse : Codable {
	let meta : Model_Meta?
	let data : Model_CommentListingData?
    let errors : Model_Errors?

	enum CodingKeys: String, CodingKey {

		case meta = "meta"
		case data = "data"
        case errors = "errors"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Model_Meta.self, forKey: .meta)
		data = try values.decodeIfPresent(Model_CommentListingData.self, forKey: .data)
        errors = try values.decodeIfPresent(Model_Errors.self, forKey: .errors)
	}
}
