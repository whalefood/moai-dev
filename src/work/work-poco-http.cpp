// Copyright (c) 2010-2011 Zipline Games, Inc. All Rights Reserved.
// http://getmoai.com

#include <Poco/Net/HTTPClientSession.h>
#include <Poco/Net/HTTPRequest.h>
#include <Poco/Net/HTTPResponse.h>
#include <Poco/StreamCopier.h>
#include <Poco/Path.h>
#include <Poco/URI.h>
#include <Poco/Exception.h>
#include <iostream>
#include <string>

using namespace Poco::Net;
using namespace Poco;
using namespace std;

//----------------------------------------------------------------//
int work_poco_http ( int argc, char** argv ) {

	try {
		
		// prepare session
		URI uri ( "http://www.cnn.com" );
		HTTPClientSession session ( uri.getHost (), uri.getPort ());

		// prepare path
		string path ( uri.getPathAndQuery ());
		if ( path.empty ()) path = "/";

		// send request
		HTTPRequest req ( HTTPRequest::HTTP_GET, path, HTTPMessage::HTTP_1_1 );
		session.sendRequest ( req );

		// get response
		HTTPResponse res;
		cout << res.getStatus () << " " << res.getReason () << endl;

		// print response
		istream &is = session.receiveResponse ( res );
		StreamCopier::copyStream ( is, cout );
	}
	catch ( Exception &ex ) {
		cerr << ex.displayText () << endl;
		return -1;
	}
	
	return 0;
}
