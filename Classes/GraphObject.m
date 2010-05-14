#import "GraphObject.h"
#import "JSON.h"

@interface GraphObject (_PrivateStuff) 


@end

@implementation GraphObject

@synthesize _properties;
@synthesize _profilePictureSmall;
@synthesize _profilePictureLarge;

#pragma mark Initialization

-(void)initSelf
{
	_profilePictureSmall = nil;
	_profilePictureLarge = nil;
}

-(id)initWithString:(NSString*)jsonString;
{
	if ( self = [super init] )
	{
		_properties = [jsonString JSONValue];
		[self initSelf];
	}
	return self;
}

-(id)initWithDict:(NSDictionary*)newProperties
{
	if ( self = [super init] )
	{
		self._properties = [[NSDictionary alloc] initWithDictionary:newProperties];
		[self initSelf];
	}
	return self;
}

-(id)init
{
	if ( self = [super init] )
	{
		_properties = nil;
		[self initSelf];
	}
	return self;
}

-(void)dealloc 
{
	[_properties release];
	[_profilePictureSmall release];
	[_profilePictureLarge release];
	
	[super dealloc];
}

#pragma mark Graph Node Property Accessors

-(id)propertyWithKey:(id)key
{
	id propertyObject = nil;
	if ( nil != self._properties )
		propertyObject = [self._properties objectForKey:key];
	return propertyObject;
}

-(NSString*)objectID
{
	return [self propertyWithKey:@"id"];
}

-(NSString*)name
{
	return [self propertyWithKey:@"name"];
}

// handle photos later, will need access to the graph
-(UIImage*)smallPicture
{
	return nil;
}

-(UIImage*)largePicture
{
	return nil;
}

@end
