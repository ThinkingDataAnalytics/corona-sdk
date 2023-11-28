---------------
-- ThinkingData Analytics Corona SDK.
-- @script TDAnalytics
---------------

local TDAnalytics = {}

local json = require( "json" )

local TE_LIB_VERSION = "2.0.1"
local TE_LIB_NAME = "Corona"

-- environment: simulator/device/browser
-- platform: android/ios/macos/tvos/win32/html5

--[[
	Initialize the native environment
]]
local function _init()
    local environment = system.getInfo( "environment" )
    if environment == "device" then
        local platform = system.getInfo("platform")
        if platform == "ios" then
            TDAnalytics.library = require "thinking.plugin.library"
        elseif platform == "android" then
            TDAnalytics.library = require "plugin.library"
        else
			print("[ThinkingEngine] Warning: current platform is < " .. platform .. " >, Event tracking is not supported.")
        end
    else
        print("[ThinkingEngine] Warning: current environment is < " .. environment .. " >, Event tracking is not supported.")
    end

    if (TDAnalytics.library ~= nil)  then
        local listener = function ( event )
			if TDAnalytics.getDistinctIdCallback and "getDistinctId" == event.type then
				local distinctId = json.decode(event.message).distinctId;
				TDAnalytics.getDistinctIdCallback(distinctId)
			elseif TDAnalytics.getDeviceIdCallback and "getDeviceId" == event.type then
				local deviceId = json.decode(event.message).deviceId;
				TDAnalytics.getDeviceIdCallback(deviceId)
			elseif TDAnalytics.getSuperPropertiesCallback and "getSuperProperties" == event.type then
				local properties = json.decode(event.message).properties;
				TDAnalytics.getSuperPropertiesCallback(properties)
			elseif TDAnalytics.getPresetPropertiesCallback and "getPresetProperties" == event.type then
				local properties = json.decode(event.message).properties;
				TDAnalytics.getPresetPropertiesCallback(properties)
			end
		end
		TDAnalytics.library.init( listener )

		local libInfo = { 
			method = "setCustomerLibInfo",
			libName = TE_LIB_NAME,
			libVersion = TE_LIB_VERSION
		}
		local encoded = json.encode( libInfo )
		TDAnalytics.library.thinkingBridging( encoded )
    else 
        TDAnalytics.library = {
            thinkingBridging = (function (params)
            end),
			init = (function (lis)
			end)
        }
    end
end

-- -- This event is dispatched to the global Runtime object
-- -- by `didLoadMain:` in MyCoronaDelegate.mm
-- function delegateListener( event )
-- 	native.showAlert(
-- 		"Event dispatched from `didLoadMain:`",
-- 		"of type: " .. tostring( event.name ),
-- 		{ "OK" } )
--     -- print( "Event dispatched from `didLoadMain:`" .. "of type: " .. tostring( event.name ) )
-- end
-- Runtime:addEventListener( "delegate", delegateListener )
-- This event is dispatched to the following Lua function
-- by PluginLibrary::show() in PluginLibrary.mm

--- SDK Initialization.
-- @tab 	params SDK Config Information
-- @string 	params.appId Project ID
-- @string 	params.serverUrl Server URL
-- @tab 	params.autoTrack Auto-tracking Event type list, e.g. "appStart", "appEnd", "appInstall"
-- @string 	params.debugMode SDK running mode, e.g. "normal", "debug", "debugOnly"
-- @bool 	params.enableLog Allowed to print logs
-- @usage
-- TDAnalytics.init({ 
-- 	appId = "YOUR_APP_ID", 
-- 	serverUrl = "YOUR_SERVER_URL" 
-- })
TDAnalytics.init = function(params)
    _init()
	if type(params) == "table" then
		params["method"] = "shareInstance"
		local encoded = json.encode( params )
		TDAnalytics.library.thinkingBridging( encoded )
	else
		print("[ThinkingEngine] Error: params in TDAnalytics.shareInstance() must be type of table.")
	end
end

--- Track a Normal Event.
-- @string 	eventName Event name
-- @tab 	properties Event properties
-- @string 	appId Project ID
-- @usage 
-- TDAnalytics.track( "TA", { 
-- 	key_1 = "value_1"
-- } )
TDAnalytics.track = function(eventName, properties, appId)
	local params = {}
	params["method"] = "track"
	params["eventName"] = eventName
	params["properties"] = properties
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Track a First Event.
-- The first event refers to the ID of a device or other dimension, which will only be recorded once.
-- @string 	eventName Event name
-- @tab 	properties Event properties
-- @string 	eventId Event ID
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.trackFirst( "FirstEvent", { 
-- 	key_1 = "value_1" 
-- })
TDAnalytics.trackFirst = function(eventName, properties, eventId, appId)
	local params = {}
	params["method"] = "trackFirst"
	params["eventName"] = eventName
	params["properties"] = properties
	params["eventId"] = eventId
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Track a Updatable Event.
-- You can implement the requirement to modify event data in a specific scenario through updatable events. 
-- Updatable events need to specify an ID that identifies the event and pass it in when the updatable event object is created.
-- @string 	eventName Event name
-- @tab 	properties Event properties
-- @string 	eventId Event ID
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.trackUpdate( "UpdateEvent", { 
-- 	key_1 = "value_1" 
-- }, "UpdateEventId" )
TDAnalytics.trackUpdate = function(eventName, properties, eventId, appId)
	local params = {}
	params["method"] = "trackUpdate"
	params["eventName"] = eventName
	params["properties"] = properties
	params["eventId"] = eventId
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Track a Overwritable Event.
-- Overwritable events will completely cover historical data with the latest data, which is equivalent to deleting the previous data and storing the latest data in effect. 
-- @string 	eventName Event name
-- @tab 	properties Event properties
-- @string 	eventId Event ID
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.trackOverwrite( "OverwriteEvent", { 
-- 	key_1 = "value_1" 
-- }, "OverwriteEventId" )
TDAnalytics.trackOverwrite = function(eventName, properties, eventId, appId)
	local params = {}
	params["method"] = "trackOverwrite"
	params["eventName"] = eventName
	params["properties"] = properties
	params["eventId"] = eventId
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Record the event duration, call this method to start the timing, 
-- stop the timing when the target event is uploaded, 
-- and add the attribute #duration to the event properties, in seconds.
-- @string 	eventName Event name
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.timeEvent( "TA" )
-- -- do something...
-- TDAnalytics.track("TA")
TDAnalytics.timeEvent = function(eventName, appId)
	local params = {}
	params["method"] = "timeEvent"
	params["eventName"] = eventName
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Sets the user property, replacing the original value with the new value if the property already exists.
-- @tab 	properties User properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userSet( { 
-- 	name = "Tiki",
-- 	age = 20
-- } )
TDAnalytics.userSet = function(properties, appId)
	local params = {}
	params["method"] = "userSet"
	params["properties"] = properties
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Sets a single user attribute, ignoring the new attribute value if the attribute already exists.
-- @string 	properties User properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userSetOnce( { 
-- 	gender = "male"
-- } )
TDAnalytics.userSetOnce = function(properties, appId)
	local params = {}
	params["method"] = "userSetOnce"
	params["properties"] = properties
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Reset user properties
-- @string 	property User property
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userUnset( "name_1" )
TDAnalytics.userUnset = function(property, appId)
	local params = {}
	params["method"] = "userUnset"
	params["property"] = property
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Adds the numeric type user attributes
-- @tab properties User properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userAdd( { 
-- 	age = 1
-- } )
TDAnalytics.userAdd = function(properties, appId)
	local params = {}
	params["method"] = "userAdd"
	params["properties"] = properties
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Append a user attribute of the List type.
-- @tab properties User properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userAppend( { 
-- 	toys = { "ball" }
-- } )
TDAnalytics.userAppend = function(properties, appId)
	local params = {}
	params["method"] = "userAppend"
	params["properties"] = properties
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- The element appended to the library needs to be done to remove the processing,and then import.
-- @tab properties User properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userUniqAppend( { 
-- 	toys = { "ball", "apple" }
-- } )
TDAnalytics.userUniqAppend = function(properties, appId)
	local params = {}
	params["method"] = "userUniqAppend"
	params["properties"] = properties
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Delete the user attributes,This operation is not reversible and should be performed with caution.
-- @string appId Project ID
-- @usage
-- TDAnalytics.userDelete()
TDAnalytics.userDelete = function(appId)
	local params = {}
	params["method"] = "userDel"
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Empty the cache queue. When this api is called, the data in the current cache queue will attempt to be reported.
-- If the report succeeds, local cache data will be deleted.
-- @string 	appId Project ID
-- @usage 
-- TDAnalytics.flush()
TDAnalytics.flush = function(appId)
	local params = {}
	params["method"] = "flush"
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Set the account ID. Each setting overrides the previous value. Login events will not be uploaded.
-- @string 	accountId Account ID
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.login( "136xxx" )
TDAnalytics.login = function(accountId, appId)
	local params = {}
	params["method"] = "login"
	params["accountId"] = accountId
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Clearing the account ID will not upload user logout events.
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.logout()
TDAnalytics.logout = function(appId)
	local params = {}
	params["method"] = "logout"
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Set the distinct ID to replace the default UUID distinct ID
-- @string 	distinctId Distinct ID
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.setDistinctId( "thinkers" )
TDAnalytics.setDistinctId = function(distinctId, appId)
	local params = {}
	params["method"] = "identify"
	params["distinctId"] = distinctId
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Get a Distinct ID: The #distinct_id value in the reported data.
-- @func 	callback Callback with Distinct ID 
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.getDistinctId( function (ret)
-- 	local distinctId = ret
-- 	print( "current distinctId = " .. distinctId )
-- end )
TDAnalytics.getDistinctId = function(callback, appId)
	TDAnalytics.getDistinctIdCallback = callback
	local params = {}
	params["method"] = "getDistinctId"
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Get a Device ID
-- @func 	callback Callback with Device ID 
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.getDeviceId( function (ret)
-- 	local deviceId = ret
-- 	print( "current deviceId = " .. deviceId )
-- end )
TDAnalytics.getDeviceId = function(callback, appId)
	TDAnalytics.getDeviceIdCallback = callback
	local params = {}
	params["method"] = "getDeviceId"
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Get SDK Version
-- @treturn	string SDK version
-- @usage
-- TDAnalytics.getSDKVersion( function (ret)
-- 	local version = ret
-- 	print( "current version = " .. version )
-- end )
TDAnalytics.getSDKVersion = function()
	return TE_LIB_VERSION;
end

---Set the public event attribute, which will be included in every event uploaded after that. The public event properties are saved without setting them each time.
-- @tab 	properties Super Properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.setSuperProperties( {
-- 	channel = "Apple Store ",
-- 	vip_level = 100
-- } )
TDAnalytics.setSuperProperties = function(properties, appId)
	local params = {}
	params["method"] = "setSuperProperties"
	params["properties"] = properties
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Clears a public event attribute
-- @tab 	property Public event attribute key to clear
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.unsetSuperProperties( "vip_level" )
TDAnalytics.unsetSuperProperties = function(property, appId)
	local params = {}
	params["method"] = "unsetSuperProperties"
	params["property"] = property
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Gets the public event properties that have been set.
-- @func 	callback Callback with public event properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.getSuperProperties( function (ret)
-- 	local superProperties = ret
-- 	print( "current superProperties = " .. superProperties )
-- end )
TDAnalytics.getSuperProperties = function(callback, appId)
	TDAnalytics.getSuperPropertiesCallback = callback
	local params = {}
	params["method"] = "getSuperProperties"
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Clear all public event attributes.
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.clearSuperProperties()
TDAnalytics.clearSuperProperties = function(appId)
	local params = {}
	params["method"] = "clearSuperProperties"
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Gets preset properties for all events.
-- @func 	callback Callback with preset properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.getPresetProperties( function (ret)
-- 	local presetProperties = ret
-- 	print( "current presetProperties = " .. presetProperties )
-- end )
TDAnalytics.getPresetProperties = function(callback, appId)
	TDAnalytics.getPresetPropertiesCallback = callback
	local params = {}
	params["method"] = "getPresetProperties"
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Calibrate Event Time with Timestamp
-- @number 	timestamp unix timestamp
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.calibrateTime(1672502400000)
TDAnalytics.calibrateTime = function(timestamp, appId)
	local params = {}
	params["method"] = "calibrateTime"
	params["timestamp"] = timestamp
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end

--- Calibrate Event Time with NTP Server
-- @string 	ntpServer ntp server url
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.calibrateTimeWithNtp("time.apple.com")
TDAnalytics.calibrateTimeWithNtp = function(ntpServer, appId)
	local params = {}
	params["method"] = "calibrateTimeWithNtp"
	params["ntpServer"] = ntpServer
	params["appId"] = appId
	local encoded = json.encode( params )
	TDAnalytics.library.thinkingBridging( encoded )
end



TDAnalytics.tableString = function (tab)
	local max_indent = 3	
	local loopTableDict = {}
	local _tableString
	function _tableString(t, indent)
		if t == nil then
			return "~nil"
		elseif type(t) == "table" then
			if loopTableDict[t] then
				return "{loopTable}"
			elseif indent < max_indent then
				loopTableDict[t] = true				
				local strs = {"{"}
				for k,v in pairs(t) do
					local key = k
					if tonumber(key) ~= nil then
						key = "[" .. key .. "]"
					end
					table.insert( strs, string.rep("    ",indent+1) .. key .. "=" .. _tableString(v, indent + 1))
				end
				table.insert(strs, string.rep("    ", indent) .. "}")
				return table.concat(strs, "\n")
			else
				return tostring(t)
			end
		elseif type(t) == "string" then
			return '"' .. t .. '"'
		else
			return tostring(t)
		end
	end
	return _tableString(tab, 0)
end


return TDAnalytics;