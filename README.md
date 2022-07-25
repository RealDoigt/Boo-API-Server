# Boo-API-Server
This is a very basic Boo web service that was made for a school assignment. Even though it's not the best web server example in the world, I think it can be interesting to look at.
This web app is essentially a string transformation service. It's not something you would really need in this form - indeed for most of it should be implemented as a library rather than be served by a web server.
But like I said, it should be a cool example toy around with if you like Boo.

On the surface level, the program is split into 3 parts:
- Request processing
- String transformation functions
- String censor functions

The latter two are not very interesting as they are very basic and weren't the focus of the assignment. The censor functions are particularly irrelevent as they work with a word list that applies only to a specific dialect of french.
What you want is in Server.boo which is the part where it listens to requests and calls the right services to respond to the request and DeconstructedRequest.boo, which facilitates the access of data in a request.
