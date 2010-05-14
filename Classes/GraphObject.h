// this class represents an object returned from the graph, parsed JSON
// it is a very thin veneer over the dictionary of properties, and is meant to
// provide more convenient domain-appropriate access than the NSDictionary API
//
// currently it is still very thin, but will grow to cover more of the graph

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

@property (nonatomic, readonly) NSString* objectID;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* error;


-(id)initWithString:(NSString*)jsonString;
-(id)initWithDict:(NSDictionary*)newProperties;

-(UIImage*)smallPicture;
-(UIImage*)largePicture;

@end
