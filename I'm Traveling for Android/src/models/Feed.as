package models
{
	public class Feed
	{
		public var feedId : int;
		public var tripId : int;
		public var userId : int;
		public var name : String
		public var profileImageURL : String;
		public var place : String;
		public var region : String;
		public var time : String;
		public var pictureURL : String;
		public var pictureThumbURL : String;
		public var pictureRatio : Number;
		public var review : String;
		public var info : Array;
		public var latitude : Number;
		public var longitude : Number;
		public var numAllFeeds : int;
		public var numLikes : int;
		public var numComments : int;
		public var comments : Array;
		
		// 모든 내용이 채워져있는지 여부
		public var complete : Boolean;
	}
}