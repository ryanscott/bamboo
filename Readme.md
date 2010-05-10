Bamboo (coming soon)
====
Bamboo (<a href="http://github.com/ryanscott/bamboo" target="_blank">http://github.com/ryanscott/bamboo</a>) is a new Facebook Graph library for use in iPhone development.  It is currently in development, and barely functions, but works just enough for me to write this.  The library is designed very similarly to Koala (<a href="http://github.com/arsduo/koala" target="_blank">http://github.com/arsduo/koala</a>), a Ruby port of the Python library that Facebook published.  The basic API structure is largely the same, and for the most part the design goals are the same.  Divergence will come over time as this library evolves, but initially I expect it to be rather isomorphic. 

To understand the GraphAPI concepts, for now read the Koala documentation and walkthrough.

Really Basic usage:

	(from MainController.m in friendgraph)

	-(void)buttonHandler
	{
		[[FacebookProxy instance] loginAndAuthorizeWithTarget:self callback:@selector(doneAuthorizing)];
	}
	
	-(void)doneAuthorizing
	{
		// FacebookProxy is useful as a way to have users login to Facebook, and a convenient way to get an access_token
		// you are welcome to use it, or provide your own facebook login mechanism

		// eithe way, the GraphAPI object is what you want.  this method creates a new GraphAPI object using the FacebookProxy's access_token
		self._graph = [[FacebookProxy instance] newGraph];

		// full JSON text of any object
		self._fullText.text = [self._graph getObject:@"me"];

		// profile picture of any object
		self._profileImage.image = [self._graph getProfilePhotoForObject:@"me"];
	}


Examples and More Details 
-----
Check the /samples/ directory, which includes code for an app named friendgraph.  I use this app as an area to develop and test new functionality.

Generally speaking, your app needs to get an access_token to use graph.facebook.api.  Once you have a token, you can pretty much keep using it ad infinitum as far as I can tell.  The FacebookProxy class handles all the login & token grabbing piping, right now using a auth sandbox setup by Alex for Koala.  That will need to change, and be handled by the lib client on an app by app basis.

vis-a-vis the to the actual Graph API, most of the complexity is going to be in Application logic.  The API itself is extremely simple, as it really should be...nice and RESTful.  I expect Bamboo to add objects for various useful entities in the Facebook space on top of the basic API calls, whereas Koala basically just keeps everything flat...as per Ruby convention.

Known Issues
-----
The lib isn't finish't yet, most API calls & methods still unfinished.

No asynchronous Graph access

No JSON parsing

no extended permissions (auth scope)
