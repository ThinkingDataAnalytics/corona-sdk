-----------------------------------------------------------------------------------------
-- ThinkingAnalyticsSDK
-----------------------------------------------------------------------------------------

local ThinkingAnalyticsAPI = {}

local json = require( "json" )

local TE_LIB_VERSION = "1.0.1"
local TE_LIB_NAME = "Corona"

-- environment: simulator/device/browser
-- platform: android/ios/macos/tvos/win32/html5

--[[
	Initialize the native environment
]]
local function init()
    local environment = system.getInfo( "environment" )
    if environment == "device" then
        local platform = system.getInfo("platform")
        if platform == "ios" then
            ThinkingAnalyticsAPI.library = require "thinking.plugin.library"
        elseif platform == "android" then
            ThinkingAnalyticsAPI.library = require "plugin.library"
        else
			print("[ThinkingEngine] Warning: current platform is < " .. platform .. " >, Event tracking is not supported.")
        end
    else
        print("[ThinkingEngine] Warning: current environment is < " .. environment .. " >, Event tracking is not supported.")
    end

    if (ThinkingAnalyticsAPI.library ~= nil)  then
        local listener = function ( event )
			if ThinkingAnalyticsAPI.getDistinctIdCallback and "getDistinctId" == event.type then
				local distinctId = json.decode(event.message).distinctId;
				ThinkingAnalyticsAPI.getDistinctIdCallback(distinctId)
			elseif ThinkingAnalyticsAPI.getDeviceIdCallback and "getDeviceId" == event.type then
				local deviceId = json.decode(event.message).deviceId;
				ThinkingAnalyticsAPI.getDeviceIdCallback(deviceId)
			elseif ThinkingAnalyticsAPI.getSuperPropertiesCallback and "getSuperProperties" == event.type then
				local properties = json.decode(event.message).properties;
				ThinkingAnalyticsAPI.getSuperPropertiesCallback(properties)
			elseif ThinkingAnalyticsAPI.getPresetPropertiesCallback and "getPresetProperties" == event.type then
				local properties = json.decode(event.message).properties;
				ThinkingAnalyticsAPI.getPresetPropertiesCallback(properties)
			end
		end
		ThinkingAnalyticsAPI.library.init( listener )

		local libInfo = { 
			method = "setCustomerLibInfo",
			libName = TE_LIB_NAME,
			libVersion = TE_LIB_VERSION
		}
		local encoded = json.encode( libInfo )
		ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
    else 
        ThinkingAnalyticsAPI.library = {
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

--[[
	SDK Initialization
	params: table
	params.appId: Project ID
	params.serverUrl: Server URL
	params.autoTrack: Auto-tracking Event type list, e.g. "appStart", "appEnd", "appInstall"
	params.debugMode: SDK running mode, e.g. "normal", "debug", "debugOnly"
	params.enableLog: Allowed to print logs
]]
ThinkingAnalyticsAPI.shareInstance = function(params)
    init()
	if type(params) == "table" then
		params["method"] = "shareInstance"
		local encoded = json.encode( params )
		ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
	else
		print("[ThinkingEngine] Error: params in ThinkingAnalyticsAPI.shareInstance() must be type of table.")
	end
end

--[[
	Track a Normal Event
	eventName: Event name
	properties: Event properties
]]
ThinkingAnalyticsAPI.track = function(eventName, properties)
	local params = {}
	params["method"] = "track"
	params["eventName"] = eventName
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Track a First Event
	The first event refers to the ID of a device or other dimension, which will only be recorded once.
	eventName: Event name
	properties: Event properties
	eventId: Event ID
]]
ThinkingAnalyticsAPI.trackFirst = function(eventName,properties,eventId)
	local params = {}
	params["method"] = "trackFirst"
	params["eventName"] = eventName
	params["properties"] = properties
	params["eventId"] = eventId
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Track a Updatable Event
	You can implement the requirement to modify event data in a specific scenario through updatable events. 
	Updatable events need to specify an ID that identifies the event and pass it in when the updatable event object is created.
	eventName: Event name
	properties: Event properties
	eventId: Event ID
]]
ThinkingAnalyticsAPI.trackUpdate = function(eventName,properties,eventId)
	local params = {}
	params["method"] = "trackUpdate"
	params["eventName"] = eventName
	params["properties"] = properties
	params["eventId"] = eventId
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Track a Overwritable Event
	Overwritable events will completely cover historical data with the latest data, which is equivalent to deleting the previous data and storing the latest data in effect. 
	eventName: Event name
	properties: Event properties
	eventId: Event ID
]]
ThinkingAnalyticsAPI.trackOverwrite = function(eventName,properties,eventId)
	local params = {}
	params["method"] = "trackOverwrite"
	params["eventName"] = eventName
	params["properties"] = properties
	params["eventId"] = eventId
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Record the event duration, call this method to start the timing, 
	stop the timing when the target event is uploaded, 
	and add the attribute #duration to the event properties, in seconds.
	eventName: Event name
]]
ThinkingAnalyticsAPI.timeEvent = function(eventName)
	local params = {}
	params["method"] = "timeEvent"
	params["eventName"] = eventName
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Sets the user property, replacing the original value with the new value if the property already exists.
	properties: User properties
]]
ThinkingAnalyticsAPI.userSet = function(properties)
	local params = {}
	params["method"] = "userSet"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Sets a single user attribute, ignoring the new attribute value if the attribute already exists.
	properties: User properties
]]
ThinkingAnalyticsAPI.userSetOnce = function(properties)
	local params = {}
	params["method"] = "userSetOnce"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Reset user properties
	property: User property
]]
ThinkingAnalyticsAPI.userUnset = function(property)
	local params = {}
	params["method"] = "userUnset"
	params["property"] = property
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Adds the numeric type user attributes
	properties: User properties
]]
ThinkingAnalyticsAPI.userAdd = function(properties)
	local params = {}
	params["method"] = "userAdd"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Append a user attribute of the List type.
	properties: User properties
]]
ThinkingAnalyticsAPI.userAppend = function(properties)
	local params = {}
	params["method"] = "userAppend"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	The element appended to the library needs to be done to remove the processing,and then import.
	properties: User properties
]]
ThinkingAnalyticsAPI.userUniqAppend = function(properties)
	local params = {}
	params["method"] = "userUniqAppend"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Delete the user attributes,This operation is not reversible and should be performed with caution.
]]
ThinkingAnalyticsAPI.userDel = function()
	local params = {}
	params["method"] = "userDel"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Empty the cache queue. When this api is called, the data in the current cache queue will attempt to be reported.
 	If the report succeeds, local cache data will be deleted.
]]
ThinkingAnalyticsAPI.flush = function()
	local params = {}
	params["method"] = "flush"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Set the account ID. Each setting overrides the previous value. Login events will not be uploaded.
	accountId: Account ID
]]
ThinkingAnalyticsAPI.login = function(accountId)
	local params = {}
	params["method"] = "login"
	params["accountId"] = accountId
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Clearing the account ID will not upload user logout events.
]]
ThinkingAnalyticsAPI.logout = function()
	local params = {}
	params["method"] = "logout"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Set the distinct ID to replace the default UUID distinct ID
	distinctId: Distinct ID
]]
ThinkingAnalyticsAPI.identify = function(distinctId)
	local params = {}
	params["method"] = "identify"
	params["distinctId"] = distinctId
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Get a Distinct ID: The #distinct_id value in the reported data.
	callback: Callback with Distinct ID 
]]
ThinkingAnalyticsAPI.getDistinctId = function(callback)
	ThinkingAnalyticsAPI.getDistinctIdCallback = callback
	local params = {}
	params["method"] = "getDistinctId"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Get a Device ID
	callback: Callback with Device ID 
]]
ThinkingAnalyticsAPI.getDeviceId = function(callback)
	ThinkingAnalyticsAPI.getDeviceIdCallback = callback
	local params = {}
	params["method"] = "getDeviceId"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Set the public event attribute, which will be included in every event uploaded after that. The public event properties are saved without setting them each time.
	properties: Super Properties
]]
ThinkingAnalyticsAPI.setSuperProperties = function(properties)
	local params = {}
	params["method"] = "setSuperProperties"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Clears a public event attribute
	property: Public event attribute key to clear
]]
ThinkingAnalyticsAPI.unsetSuperProperties = function(property)
	local params = {}
	params["method"] = "unsetSuperProperties"
	params["property"] = property
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Gets the public event properties that have been set.
	callback: Callback with public event properties
]]
ThinkingAnalyticsAPI.getSuperProperties = function(callback)
	ThinkingAnalyticsAPI.getSuperPropertiesCallback = callback
	local params = {}
	params["method"] = "getSuperProperties"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Clear all public event attributes.
]]
ThinkingAnalyticsAPI.clearSuperProperties = function()
	local params = {}
	params["method"] = "clearSuperProperties"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
--[[
	Gets preset properties for all events.
	callback: Callback with preset properties
]]
ThinkingAnalyticsAPI.getPresetProperties = function(callback)
	ThinkingAnalyticsAPI.getPresetPropertiesCallback = callback
	local params = {}
	params["method"] = "getPresetProperties"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end

ThinkingAnalyticsAPI.tableString = function (tab)
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


return ThinkingAnalyticsAPI;