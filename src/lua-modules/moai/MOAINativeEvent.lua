MOAINativeEvent = {}

local platformSpecifcObj = MOAINativeEventIOS or MOAINativeEventAndroid or nil;

MOAINativeEvent.triggerEvent = function(eventName, paramTable)
    if not platformSpecifcObj then return nil end
    local paramString = MOAIJsonParser.encode(paramTable);
    local rtnString = MOAINativeEventIOS.triggerEvent(eventName,paramString);
    return MOAIJsonParser.decode(rtnString);
end
