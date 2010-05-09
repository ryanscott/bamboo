@class GraphAPI;

@interface MainController : UIViewController
{
	GraphAPI* _graph;
	
	UIButton* _authButton;
	UILabel* _statusInfo;
	UIImageView* _profileImage;

	UITextView* _fullText;
}

@property (nonatomic, retain) GraphAPI* _graph;

@property (nonatomic, retain) UIButton* _authButton;
@property (nonatomic, retain) UILabel* _statusInfo;
@property (nonatomic, retain) UIImageView* _profileImage;

@property (nonatomic, retain) UITextView* _fullText;

-(void)doneAuthorizing;

@end
