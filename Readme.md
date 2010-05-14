Bamboo
====
Bamboo (<a href="http://github.com/ryanscott/bamboo" target="_blank">http://github.com/ryanscott/bamboo</a>) is a new Facebook Graph library for use in iPhone development.  Bamboo is a simple, lightweight, robust alternative to using the old Facebook Connect API, and a time-saving alternative to directly writing your own network code.  The library is designed very similarly to Koala (<a href="http://github.com/arsduo/koala" target="_blank">http://github.com/arsduo/koala</a>), a Ruby port of the Python library that Facebook published.  Bamboo is more or less an objective-c port of the ruby port.  The basic API structure is the same, and for the most part the design goals are the same.

This is as easy as it gets at integrating Facebook into an iPhone application.  Using Bamboo will save you hours, probably days, of development time.

To understand the GraphAPI concepts from the perspective of a third-party library, read the Koala documentation and walkthrough.

<a href="http://wiki.github.com/arsduo/koala/" target="_blank">http://wiki.github.com/arsduo/koala/</a>

Alex also wrote a fabulous, very in-depth tutorial on how to use Koala, and everything he says applies to Bamboo, even the method names are the same, for your convenience.

<a href="http://blog.twoalex.com/2010/05/03/introducing-koala-a-new-gem-for-facebooks-new-graph-api/" target="_blank">http://blog.twoalex.com/2010/05/03/introducing-koala-a-new-gem-for-facebooks-new-graph-api/</a>

Sample usage:

	[[FacebookProxy instance] loginAndAuthorizeWithTarget:self callback:@selector(finishedAuthorizing)];
	GraphAPI* graph = [[FacebookProxy instance] newGraph];

	GraphObject* me = [graph getObject:@"me"];
	NSString* myName = me.name;
	
	UIImage* myProfileImage = [me largePicture];

	NSArray* thingsILike = [graph getConnections:@"likes" forObject:me.objectID];
	
	// update status message to my feed/wall
	NSDictionary* args = [NSDictionary dictionaryWithObjectsAndKeys:@"Hello World, from bamboo!", @"message", nil];
	[self._graph putToObject:me.objectID connectionType:@"feed" args:args];

	// add a like connection from me to you
	[self._graph likeObject:@"<you>"]

Integration Instructions
-----

<ol>
	<li>Install bamboo and dependencies from your project directory:</li>

<pre><code>git clone http://github.com/ryanscott/bamboo.git
git clone http://github.com/facebook/facebook-iphone-sdk.git
git clone http://github.com/stig/json-framework.git</pre></code>

<li>Open your project, make a group called "Libraries," and add all source files from bamboo, json-framework, and facebook-iphone-sdk</li>

<li>Define the following 4 global variables:</li>

<pre><code>NSString* const kFBAPIKey = @"<your_facebook_api_key>";
NSString* const kFBAppSecret = @"<your_facebook_app_secret>";
NSString* const kFBClientID = @"<your_facebook_client_id>";
NSString* const kFBRedirectURI = @"<redirect_url_for_oath>";</pre></code>

If you need help on any of those, get help at <a href="http://developers.facebook.com/docs/api#authorization" target="_blank">http://developers.facebook.com/docs/api#authorization</a> or <a href="http://oauth.twoalex.com/" target="_blank">http://oauth.twoalex.com/</a>

<br/><br/>
See Constants.m in samples/testgraph for example values.

<li>Include "GraphAPI.h" write the following 2-ish lines of code in your klass.m:</li>

<pre><code>// klass.m
[[FacebookProxy instance] loginAndAuthorizeWithTarget:self callback:@selector(finishedAuthorizing)];

-(void)finishedAuthorizing
{
	self._graph = [[FacebookProxy instance] newGraph];
}

// klass.h
GraphAPI* _graph; 
@property (nonatomic, retain) GraphAPI* _graph;</pre></code>

<li>Make calls to the Facebook graph using your GraphAPI object.</li>
</ol>
See GraphAPI.h for interface.  See /samples/testgraph/PadRootController.m for some example usage.

More documentation and more extensive sample app forthcoming.

Examples and More Details 
-----
Check the /samples/ directory, which includes code for an app named testgraph.  I use this app as an area to develop and test new functionality.

The main integration point is FacebookProxy, which handles all of the messiness of authorization.  The following 4 variables need to be defined in your app.  See Constants.m in testgraph for example values.

<pre><code>// Facebook API
// all of these values need to be set in the client application
extern NSString* const kFBAPIKey;
extern NSString* const kFBAppSecret;

extern NSString* const kFBClientID;
extern NSString* const kFBRedirectURI;</pre></code>

Generally speaking, your app needs to get an access_token to use graph.facebook.api.  Once you have a token, you can pretty much keep using it ad infinitum as far as I can tell.  The FacebookProxy class handles all the login & token grabbing piping, right now using a oAuth sandbox setup by Alex for Koala.  That will need to be handled by the lib client on an app by app basis.

Dependencies
-----

Bamboo relies on the official Facebook Connect iPhone SDK for login.  Additionally, I use json-framework for parsing the responses from Facebook.  Both of these are not 100% necessary in theory, so if you want a version of bamboo with no dependencies whatsoever it can easily be done...it just won't be very usable.

<a href="http://github.com/facebook/facebook-iphone-sdk" target="_blank">http://github.com/facebook/facebook-iphone-sdk</a><br/>
<a href="http://github.com/stig/json-framework" target="_blank">http://github.com/stig/json-framework</a>

Known Issues
-----
No asynchronous network access

Contributions
-----
Being a really early stage library, Bamboo will most certainly need work to support all the various app environments.  I have designed the base library to meet the most common needs that I have imagined, and as the user base grows, I expect the API to grow as well.  If you are using the library, or want to use it, and your needs are only partially met, please let me know so I can grow the library design to meet your needs.

If you are interested in contributing to Bamboo, by all means please contact me (ryan (at) ryanstubblefield [dot] net).  I welcome anyone who wants to help, and prefer to keep forks at a minimum.

Contact / About Me
-----
The best, most direct way to reach me is via email (ryan (at) ryanstubblefield [dot] net).

You can find out more about me at <a href="http://www.ryanstubblefield.net/" target="_blank">http://www.ryanstubblefield.net/</a>
