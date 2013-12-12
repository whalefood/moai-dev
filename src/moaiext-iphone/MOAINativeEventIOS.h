//
//  MOAINativeEventIOS.h
//  libmoai
//
//  Created by Jonah Wallerstein on 12/10/13.
//
//

#ifndef MOAINativeEventIOS_H
#define MOAINativeEventIOS_H

#import <Foundation/Foundation.h>
#import <moaicore/moaicore.h>

//================================================================//
// MOAINativeEvent
//================================================================//
/**	@name	MOAINativeEventIOS
 @text	A class for easily hooking into native events without needing to write moai extention classes
 */
class MOAINativeEventIOS :
	public MOAIGlobalClass < MOAINativeEventIOS, MOAILuaObject > {
private:
	
	//----------------------------------------------------------------//
	static int	_triggerEvent		( lua_State* L );
	
		static int	_test		( lua_State* L );
public:
	
	DECL_LUA_SINGLETON ( MOAINativeEventIOS )
	
	//----------------------------------------------------------------//
	MOAINativeEventIOS			();
	~MOAINativeEventIOS			();
	void	RegisterLuaClass	( MOAILuaState& state );
	
};


typedef NSDictionary* (^GenericEventHandler)(NSDictionary*);

@interface MOAINativeEventRegistrar : NSObject {
@public
};

+(void) RegisterEventListenerWithName:(NSString*)name method:(GenericEventHandler) handler;

@end


#endif
