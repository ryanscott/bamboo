#import "GraphObject.h"
#import "JSON.h"
#import "GraphAPI.h"

@interface GraphObject (_PrivateStuff) 
-(GraphAPI*)getGraph;
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
		_properties = [[NSDictionary alloc] initWithDictionary:[jsonString JSONValue]];
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

-(NSString*)error
{
	return [self propertyWithKey:@"error"];
}

// [ryan:5-14-10] todo
// redo photos later, will need access to the graphAPI object, not sure how I want to make that accessible here
// I want to be able to lazy-load them and not force the client to keep track of anything


-(GraphAPI*)getGraph
{
	// this will work for now, to lazy-load images and not force client to know or keep track of anything
	// not a good long-term, general purpose solution
	return [[FacebookProxy instance] newGraph];
}

-(UIImage*)smallPicture
{
	if ( nil == _profilePictureSmall )
	{
		GraphAPI* graph = [self getGraph];
		self._profilePictureSmall = [graph getProfilePhotoForObject:self.objectID];
	}
  return self._profilePictureSmall;
}

-(UIImage*)largePicture
{
	if ( nil == _profilePictureLarge )
	{
		GraphAPI* graph = [self getGraph];
		self._profilePictureLarge = [graph getLargeProfilePhotoForObject:self.objectID];
	}
  return self._profilePictureLarge;
}

@end
