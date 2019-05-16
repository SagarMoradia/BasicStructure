
import Foundation

struct HomeCategoryDataModel : Codable {
    
	let meta : Model_Meta?
	let data : [Cat_Info]?
    let errors : Model_Errors?

	enum CodingKeys: String, CodingKey {
		case meta = "meta"
		case data = "data"
        case errors = "errors"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Model_Meta.self, forKey: .meta)
		data = try values.decodeIfPresent([Cat_Info].self, forKey: .data)
        errors = try values.decodeIfPresent(Model_Errors.self, forKey: .errors)
	}
}


struct Cat_Info : Codable {
    
    let home_content_info : HomeContent_Info?
    let videos_info : [VideoData_Info]?
    
    enum CodingKeys: String, CodingKey {
        case home_content_info = "home_content_info"
        case videos_info = "videos_info"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        home_content_info = try values.decodeIfPresent(HomeContent_Info.self, forKey: .home_content_info)
        videos_info = try values.decodeIfPresent([VideoData_Info].self, forKey: .videos_info)
    }
}

struct HomeContent_Info : Codable {
    
    let uuid : String?
    let name : String?
    let slug : String?
    let totalRecords : Int?
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case name = "name"
        case slug = "slug"
        case totalRecords = "totalRecords"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        totalRecords = try values.decodeIfPresent(Int.self, forKey: .totalRecords)
    }
}

struct VideoData_Info : Codable {
    
    let mediaid : String?
    let description : String?
    let pubdate : Int?
    let tags : String?
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
    let slug:String?
    let jw_media_id:String?
    let thumbnail:String?
    let status:String?
    let publish_date:String?
    let view_count:String?
    let today_view_count:String?
    let user_uuid:String?
    let user_id:Int?
    let user_name:String?
    let user_image:String?
    let category:[categories]?
    let video_auto_play:String?
    let recommendations:String?
    let thumbnail_480:String?
    let username:String?
    
    enum CodingKeys: String, CodingKey {
        case mediaid                  = "mediaid"
        case description              = "description"
        case pubdate                  = "pubdate"
        case tags                     = "tags"
        case image                    = "image"
        case title                    = "title"
        case link                     = "link"
        case duration                 = "duration"
        case date                     = "date"
        case views                    = "views"
        case video_author_profile_pic = "video_author_profile_pic"
        case video_author_name        = "video_author_name"
        case video_uuid               = "video_uuid"
        case visitors_uuid            = "visitors_uuid"
        case category_name            = "category_name"
        case thumbnail_480            = "thumbnail_480"
        
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
        case username  = "username"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        mediaid = try values.decodeIfPresent(String.self, forKey: .mediaid)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        pubdate = try values.decodeIfPresent(Int.self, forKey: .pubdate)
        tags = try values.decodeIfPresent(String.self, forKey: .tags)
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
        username  = try values.decodeIfPresent(String.self, forKey: .username)
    }
    
}


/*
 {
     "mediaid": "THoHUg2n",
     "description": "new",
     "tags": "",
     "image": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/video_thumbs/18518/thumbnails/320x320/THUMB_320_155652846718518.jpg",
     "thumbnail_480": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/video_thumbs/18518/thumbnails/480x480/THUMB_480_155652846718518.jpg",
     "title": "its latest",
     "link": "https://cdn.jwplayer.com/previews/THoHUg2n",
     "duration": 0,
     "views": "0",
     "date": "1 minute ago",
     "slug": "its-latest-18518",
     "video_uuid": "9e42d15d-69cb-42b3-b006-00045712c003",
     "video_author_name": "vasimmm",
     "user_name": "vasimmm",
     "video_auto_play": "https://video.theweedtube.com/videos/THoHUg2n.mp4",
     "video_author_profile_pic": "https://weedtube.s3.ap-south-1.amazonaws.com/uploads/images/user/131088/profile/",
     "visitors_uuid": "209d8ae9-b549-44f4-b36a-5108e5685263",
     "creater_by": 131088
 }
 */
