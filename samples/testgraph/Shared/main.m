int main(int argc, char *argv[]) 
{    
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal;
#ifdef __IPHONE_3_2
//#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED
	if ( IS_IPAD )
		retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate_Pad");
	else
		retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate_Phone");	
#else
	retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate_Phone");	
#endif
	
	[pool release];
	return retVal;
}
