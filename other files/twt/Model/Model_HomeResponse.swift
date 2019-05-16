
import Foundation

struct ModelHomeParent {
    let type:String?
    let videoList:[Model_VideoData]?
    let footerAdsUrl:String?
}

struct Model_HomeResponse : Codable {
	let meta : Model_Meta?
    let title : String?
	let data : [Model_VideoData]?
    let errors : Model_Errors?

	enum CodingKeys: String, CodingKey {

		case meta = "meta"
        case title = "title"
		case data = "data"
        case errors = "errors"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Model_Meta.self, forKey: .meta)
        title = try values.decodeIfPresent(String.self, forKey: .title)
		data = try values.decodeIfPresent([Model_VideoData].self, forKey: .data)
        errors = try values.decodeIfPresent(Model_Errors.self, forKey: .errors)
	}
}


struct Model_VideoData : Codable {
    
    let mediaid : String?
    let description : String?
    let pubdate : Int?
    //let tags : String?
    let image : String?
    let title : String?
    let link : String?
    let duration : Int?
    let date : String?
    let views : String?
    let video_author_profile_pic : String?
    let video_author_name : String?
    let video_uuid : String?
    let visitors_uuid : String?
    let category_name : String?
    
    //For Featured
    let id:Int?
    let uuid:String?
    //let title:String?
    let slug:String?
    let jw_media_id:String?
    let thumbnail:String?
    //let duration:String?
    let status:String?
    //let description:String?
    let publish_date:String?
    let view_count:String?
    let today_view_count:String?
    let user_uuid:String?
    let user_id:Int?
    let user_name:String?
    let user_image:String?
    let category:[categories]?
    //let link:String?
    let video_auto_play:String?
    let recommendations:String?
    let thumbnail_480:String?
    
    enum CodingKeys: String, CodingKey {
        
        case mediaid = "mediaid"
        case description = "description"
        case pubdate = "pubdate"
        //case tags = "tags"
        case image = "image"
        case title = "title"
        case link = "link"
        case duration = "duration"
        case date = "date"
        case views = "views"
        case video_author_profile_pic = "video_author_profile_pic"
        case video_author_name = "video_author_name"
        case video_uuid = "video_uuid"
        case visitors_uuid = "visitors_uuid"
        case category_name = "category_name"
        case thumbnail_480 = "thumbnail_480"
        
        //For Featured
        case id               = "id"
        case uuid             = "uuid"
        case slug             = "slug"
        case jw_media_id      = "jw_media_id"
        case thumbnail        = "thumbnail"
        case status           = "status"
        case publish_date     = "publish_date"
        case view_count       = "view_count"
        case today_view_count = "today_view_count"
        case user_uuid        = "user_uuid"
        case user_id          = "user_id"
        case user_name        = "user_name"
        case user_image       = "user_image"
        case category         = "category"
        case video_auto_play  = "video_auto_play"
        case recommendations  = "recommendations"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mediaid = try values.decodeIfPresent(String.self, forKey: .mediaid)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        pubdate = try values.decodeIfPresent(Int.self, forKey: .pubdate)
        //tags = try values.decodeIfPresent(String.self, forKey: .tags)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        views = try values.decodeIfPresent(String.self, forKey: .views)
        video_author_profile_pic = try values.decodeIfPresent(String.self, forKey: .video_author_profile_pic)
        video_author_name = try values.decodeIfPresent(String.self, forKey: .video_author_name)
        video_uuid = try values.decodeIfPresent(String.self, forKey: .video_uuid)
        visitors_uuid = try values.decodeIfPresent(String.self, forKey: .visitors_uuid)
        category_name = try values.decodeIfPresent(String.self, forKey: .category_name)
        
        //For Featured
        id               = try values.decodeIfPresent(Int.self, forKey: .id)
        uuid             = try values.decodeIfPresent(String.self, forKey: .uuid)
        slug             = try values.decodeIfPresent(String.self, forKey: .slug)
        jw_media_id      = try values.decodeIfPresent(String.self, forKey: .jw_media_id)
        thumbnail        = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        status           = try values.decodeIfPresent(String.self, forKey: .status)
        publish_date     = try values.decodeIfPresent(String.self, forKey: .publish_date)
        view_count       = try values.decodeIfPresent(String.self, forKey: .view_count)
        today_view_count = try values.decodeIfPresent(String.self, forKey: .today_view_count)
        user_uuid        = try values.decodeIfPresent(String.self, forKey: .user_uuid)
        user_id          = try values.decodeIfPresent(Int.self, forKey: .user_id)
        user_name        = try values.decodeIfPresent(String.self, forKey: .user_name)
        user_image       = try values.decodeIfPresent(String.self, forKey: .user_image)
        category         = try values.decodeIfPresent([categories].self, forKey: .category)
        video_auto_play  = try values.decodeIfPresent(String.self, forKey: .video_auto_play)
        recommendations  = try values.decodeIfPresent(String.self, forKey: .recommendations)
        
        thumbnail_480  = try values.decodeIfPresent(String.self, forKey: .thumbnail_480)
    }
    
}
