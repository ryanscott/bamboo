int main(int argc, char *argv[]) 
{    
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal;
	if ( IS_IPAD )
		retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate_Pad");
	else
		retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate_Phone");		
	[pool release];
	return retVal;
}
