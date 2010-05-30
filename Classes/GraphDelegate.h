// this is used to handle async network requests
// if you are using the GraphAPI is synchronous mode, you can ignore this class

@interface GraphDelegate : NSObject 
{
	NSMutableData* _responseData;

}

@property (nonatomic, retain) NSMutableData* _responseData;

@end
