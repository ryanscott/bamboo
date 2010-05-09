@class GraphAPI;

@interface MainController : UIViewController
{
	NSMutableData* _responseText;
	
	UILabel* _statusInfo;
	UIImageView* _profileImage;

	GraphAPI* _graph;
}

@property (nonatomic, retain) NSMutableData* _responseText;

@property (nonatomic, retain) UILabel* _statusInfo;
@property (nonatomic, retain) UIImageView* _profileImage;

@property (nonatomic, retain) GraphAPI* _graph;

-(void)doneAuthorizing;

@end
