@class GraphAPI;

@interface PadRootController : UIViewController 
{
	GraphAPI* _graph;
	
	UIButton* _authButton;
	UIButton* _postButton;
	UIButton* _testButton;
	UIButton* _walkButton;
	UILabel* _statusInfo;
	UIImageView* _profileImage;
	
	UITextView* _fullText;
}

@property (nonatomic, retain) GraphAPI* _graph;

@property (nonatomic, retain) UIButton* _authButton;
@property (nonatomic, retain) UIButton* _postButton;
@property (nonatomic, retain) UIButton* _testButton;
@property (nonatomic, retain) UIButton* _walkButton;
@property (nonatomic, retain) UILabel* _statusInfo;
@property (nonatomic, retain) UIImageView* _profileImage;

@property (nonatomic, retain) UITextView* _fullText;

-(void)doneAuthorizing;

@end
