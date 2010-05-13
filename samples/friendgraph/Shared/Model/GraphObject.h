@interface GraphObject : NSObject 
{
	NSDictionary* _properties;
@private
	UIImage* _profilePictureSmall;
	UIImage* _profilePictureLarge;
}

@property (nonatomic, retain) NSDictionary* _properties;

@property (nonatomic, retain) UIImage* _profilePictureSmall;
@property (nonatomic, retain) UIImage* _profilePictureLarge;

-(id)initWithString:(NSString*)jsonString;
-(id)initWithDict:(NSDictionary*)newProperties;

// graph node property accessors
-(NSString*)objectID;
-(NSString*)name;
-(UIImage*)smallPicture;
-(UIImage*)largePicture;

@end
