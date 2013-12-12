//
//  MOAINativeEventIOS.m
//  libmoai
//
//  Created by Jonah Wallerstein on 12/10/13.
//
//

#include "pch.h"
#import "MOAINativeEventIOS.h"


@implementation MOAINativeEventRegistrar



static NSMutableDictionary* handlerCollection;


+(void) RegisterEventListenerWithName:(NSString*)name method:(GenericEventHandler) handler
{
	if(!handlerCollection)
	{
		handlerCollection = [[NSMutableDictionary alloc] init];
	}
	
	[handlerCollection setValue:(id)handler forKey:name];
}

+(NSString*) HandleEventNamed:(NSString*)name parameters:(NSString*)jsonParams
{
	GenericEventHandler handler = (GenericEventHandler)[handlerCollection objectForKey:name];
	if(!handler)
	{
		return NULL;
	}
	NSError *e = nil;
	NSDictionary * paramDic = [NSJSONSerialization JSONObjectWithData:[jsonParams dataUsingEncoding:NSUTF8StringEncoding]
															  options: NULL error: &e];
	
	NSDictionary * rtnval = handler(paramDic);
	
	if(rtnval)
	{
		NSData* rtnData = [NSJSONSerialization dataWithJSONObject:rtnval options:NULL error:&e];
		if(rtnData)
		{
			return [[NSString alloc] initWithData:rtnData
										 encoding:NSUTF8StringEncoding];
		}
	}
	
	return NULL;
}

@end


//================================================================//
// lua
//================================================================//

//----------------------------------------------------------------//
/**	@name	triggerEvent
 @text	Triggers a native-code event.  There is overhead involved in using this generic method, so it should not be used for frequent events
 
 @in		string		eventName		The name of the triggered event
 @in		string		jsonParams		A string of json data used for input parameters
 @out		string		jsonRtnval		Json data used as return value
 */
int MOAINativeEventIOS::_triggerEvent(lua_State* L ) {
	
	MOAILuaState state ( L );
	
	cc8* eventName = state.GetValue < cc8* >( 1, "" );
	cc8* jsonParams = state.GetValue < cc8* >( 2, "" );
	
	NSString* jsonRtnval = [MOAINativeEventRegistrar HandleEventNamed:[NSString stringWithUTF8String:eventName] parameters:[NSString stringWithUTF8String:jsonParams]];
	
	lua_pushstring ( L, [jsonRtnval UTF8String ] );
	return 1;
}

int	MOAINativeEventIOS::_test( lua_State* L )
{
	MOAILuaState state ( L );
	cc8* eventName = state.GetValue < cc8* >( 1, "" );
	NSLog([NSString stringWithUTF8String:eventName] );
		  return 0;
}

//================================================================//
// MOAINativeEventIOS
//================================================================//

//----------------------------------------------------------------//
MOAINativeEventIOS::MOAINativeEventIOS () {
	
	RTTI_SINGLE ( MOAILuaObject )
}

//----------------------------------------------------------------//
MOAINativeEventIOS::~MOAINativeEventIOS () {
}

//----------------------------------------------------------------//
void MOAINativeEventIOS::RegisterLuaClass ( MOAILuaState& state ) {
	
	luaL_Reg regTable [] = {
		{ "triggerEvent",	_triggerEvent },
		{ "test",	_test },
		{ NULL, NULL }
	};
	
	luaL_register ( state, 0, regTable );
}