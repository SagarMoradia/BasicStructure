import Foundation
struct Model_VideoDetailResponse : Codable {
	let meta : Model_Meta?
	let data : Model_VideoDetailData?
    let errors : Model_Errors?

	enum CodingKeys: String, CodingKey {

		case meta = "meta"
		case data = "data"
        case errors = "errors"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Model_Meta.self, forKey: .meta)
		data = try values.decodeIfPresent(Model_VideoDetailData.self, forKey: .data)
        errors = try values.decodeIfPresent(Model_Errors.self, forKey: .errors)
	}
}

class Model_VideoDetailData : Codable {
    let video_id : Int?
    let video_uuid : String?
    let title : String?
    let slug : String?
    let jw_media_id : String?
    let thumbnail : String?
    let cover_photo : String?
    let type : String?
    let duration : Int?
    let created_by : Int?
    let status : String?
    let privacy : String?
    let description : String?
    let publish_date : String?
    let view_count : Int?
    let today_view_count : Int?
    var like_count : Int?
    var dislike_count : Int?
    var comment_count : Int?
    let report_total_abuse : Int?
    let user_uuid : String?
    let first_name : String?
    let last_name : String?
    let total_followers : Int?
    let profile_image : String?
    let userid : Int?
    let joined_dt : String?
    let profile_image_100x100 : String?
    let video_preview : String?
    let video_auto_play : String?
    let date : String?
    let thumb_image : String?
    let tags : [String]?
    let category : [Category]?
    var is_like : String?
    var is_follow : String?
    let video_web_url : String?
    let vast_ad_xml_url : String?
    
    var desc_mobile : String?
    var username : String?
    
    enum CodingKeys: String, CodingKey {
        
        case video_id = "video_id"
        case video_uuid = "video_uuid"
        case title = "title"
        case slug = "slug"
        case jw_media_id = "jw_media_id"
        case thumbnail = "thumbnail"
        case cover_photo = "cover_photo"
        case type = "type"
        case duration = "duration"
        case created_by = "created_by"
        case status = "status"
        case privacy = "privacy"
        case description = "description"
        case publish_date = "publish_date"
        case view_count = "view_count"
        case today_view_count = "today_view_count"
        case like_count = "like_count"
        case dislike_count = "dislike_count"
        case comment_count = "comment_count"
        case report_total_abuse = "report_total_abuse"
        case user_uuid = "user_uuid"
        case first_name = "first_name"
        case last_name = "last_name"
        case total_followers = "total_followers"
        case profile_image = "profile_image"
        case userid = "userid"
        case joined_dt = "joined_dt"
        case profile_image_100x100 = "profile_image_100x100"
        case video_preview = "video_preview"
        case video_auto_play = "video_auto_play"
        case date = "date"
        case thumb_image = "thumb_image"
        case tags = "tags"
        case category = "category"
        case is_like = "is_like"
        case is_follow = "is_follow"
        case video_web_url = "video_web_url"
        case vast_ad_xml_url = "vast_ad_xml_url"
        case username = "username"
        case desc_mobile = "desc_mobile"
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        video_id = try values.decodeIfPresent(Int.self, forKey: .video_id)
        video_uuid = try values.decodeIfPresent(String.self, forKey: .video_uuid)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        jw_media_id = try values.decodeIfPresent(String.self, forKey: .jw_media_id)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        cover_photo = try values.decodeIfPresent(String.self, forKey: .cover_photo)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        created_by = try values.decodeIfPresent(Int.self, forKey: .created_by)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        publish_date = try values.decodeIfPresent(String.self, forKey: .publish_date)
        view_count = try values.decodeIfPresent(Int.self, forKey: .view_count)
        today_view_count = try values.decodeIfPresent(Int.self, forKey: .today_view_count)
        like_count = try values.decodeIfPresent(Int.self, forKey: .like_count)
        dislike_count = try values.decodeIfPresent(Int.self, forKey: .dislike_count)
        comment_count = try values.decodeIfPresent(Int.self, forKey: .comment_count)
        report_total_abuse = try values.decodeIfPresent(Int.self, forKey: .report_total_abuse)
        user_uuid = try values.decodeIfPresent(String.self, forKey: .user_uuid)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        total_followers = try values.decodeIfPresent(Int.self, forKey: .total_followers)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
        userid = try values.decodeIfPresent(Int.self, forKey: .userid)
        joined_dt = try values.decodeIfPresent(String.self, forKey: .joined_dt)
        profile_image_100x100 = try values.decodeIfPresent(String.self, forKey: .profile_image_100x100)
        video_preview = try values.decodeIfPresent(String.self, forKey: .video_preview)
        video_auto_play = try values.decodeIfPresent(String.self, forKey: .video_auto_play)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        thumb_image = try values.decodeIfPresent(String.self, forKey: .thumb_image)
        tags = try values.decodeIfPresent([String].self, forKey: .tags)
        category = try values.decodeIfPresent([Category].self, forKey: .category)
        is_like = try values.decodeIfPresent(String.self, forKey: .is_like)
        is_follow = try values.decodeIfPresent(String.self, forKey: .is_follow)
        video_web_url = try values.decodeIfPresent(String.self, forKey: .video_web_url)
        vast_ad_xml_url = try values.decodeIfPresent(String.self, forKey: .vast_ad_xml_url)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        desc_mobile = try values.decodeIfPresent(String.self, forKey: .desc_mobile)
    }
    
}

struct Category : Codable {
    let id : Int?
    let name : String?
    let slug : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case slug = "slug"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
    }
    
}
