
import Foundation

struct Model_Logout : Codable {
	let meta : Model_Meta?
    let errors : Model_Errors?

	enum CodingKeys: String, CodingKey {

		case meta = "meta"
        case errors = "errors"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Model_Meta.self, forKey: .meta)
        errors = try values.decodeIfPresent(Model_Errors.self, forKey: .errors)
	}
}
