-----------------------------------------------------------------------------------------
-- ThinkingAnalyticsSDK
-----------------------------------------------------------------------------------------

local ThinkingAnalyticsAPI = {}

local json = require( "json" )

local LIB_VERSION = "1.0.0"
local LIB_NAME = "Corona"

-- environment: simulator/device/browser
-- platform: android/ios/macos/tvos/win32/html5

ThinkingAnalyticsAPI.init = function ()
    local environment = system.getInfo( "environment" )
    if environment == "device" then
        local platform = system.getInfo("platform")
        print("@Thinking 当前平台< " .. platform .. " >")
        if platform == "ios" then
            ThinkingAnalyticsAPI.library = require "thinking.plugin.library"
        elseif platform == "android" then
            ThinkingAnalyticsAPI.library = require "plugin.library"
        else
            print("@Thinking 当前平台 <" .. platform .. "> 暂不支持上报数据")
        end
    else
        print("@Thinking 当前模式 <" .. environment .. "> 暂不支持上报数据")
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
			libName = LIB_NAME,
			libVersion = LIB_VERSION
		}
		local encoded = json.encode( libInfo )
		ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
    else 
        ThinkingAnalyticsAPI.library = {
            thinkingBridging = function (params)
                print("@Thinking 无法执行: " .. tostring(params))
            end
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

ThinkingAnalyticsAPI.shareInstance = function(params)
    ThinkingAnalyticsAPI.init()
	if type(params) == "table" then
		params["method"] = "shareInstance"
		local encoded = json.encode( params )
		ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
	else
		print( "parameters must be type of table" )		
	end
end
ThinkingAnalyticsAPI.track = function(eventName, properties)
	local params = {}
	params["method"] = "track"
	params["eventName"] = eventName
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.trackFirst = function(eventName,properties,eventId)
	local params = {}
	params["method"] = "trackFirst"
	params["eventName"] = eventName
	params["properties"] = properties
	params["eventId"] = eventId
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.trackUpdate = function(eventName,properties,eventId)
	local params = {}
	params["method"] = "trackUpdate"
	params["eventName"] = eventName
	params["properties"] = properties
	params["eventId"] = eventId
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.trackOverwrite = function(eventName,properties,eventId)
	local params = {}
	params["method"] = "trackOverwrite"
	params["eventName"] = eventName
	params["properties"] = properties
	params["eventId"] = eventId
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.timeEvent = function(eventName)
	-- local params = {
	-- 	method = "timeEvent",
	-- 	eventName = "TA"
	-- }
	local params = {}
	params["method"] = "timeEvent"
	params["eventName"] = eventName
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.userSet = function(properties)
	-- local params = {
	-- 	method = "userSet",
	-- 	properties = { 
	-- 		name = "Tiki"
	-- 	}
	-- }
	local params = {}
	params["method"] = "userSet"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.userSetOnce = function(properties)
	-- local params = {
	-- 	method = "userSetOnce",
	-- 	properties = { 
	-- 		name = "Tiki"
	-- 	}
	-- }
	local params = {}
	params["method"] = "userSetOnce"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.userUnset = function(property)
	-- local params = {
	-- 	method = "userUnset",
	-- 	property = "name"
	-- }
	local params = {}
	params["method"] = "userUnset"
	params["property"] = property
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.userAdd = function(properties)
	-- local params = {
	-- 	method = "userAdd",
	-- 	properties = { 
	-- 		age = 1
	-- 	}
	-- }
	local params = {}
	params["method"] = "userAdd"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.userAppend = function(properties)
	-- local params = {
	-- 	method = "userAppend",
	-- 	properties = { 
	-- 		toys = { "ball" }
	-- 	}
	-- }
	local params = {}
	params["method"] = "userAppend"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.userUniqAppend = function(properties)
	-- local params = {
	-- 	method = "userUniqAppend",
	-- 	properties = { 
	-- 		toys = { "ball", "Apple" }
	-- 	}
	-- }
	local params = {}
	params["method"] = "userUniqAppend"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.userDel = function()
	-- local params = {
	-- 	method = "userDel"
	-- }
	local params = {}
	params["method"] = "userDel"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.flush = function()
	-- local params = {
	-- 	method = "flush"
	-- }
	local params = {}
	params["method"] = "flush"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.login = function(accountId)
	-- local params = {
	-- 	method = "login",
	-- 	accountId = "136"
	-- }
	local params = {}
	params["method"] = "login"
	params["accountId"] = accountId
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.logout = function()
	-- local params = {
	-- 	method = "logout"
	-- }
	local params = {}
	params["method"] = "logout"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.identify = function(distinctId)
	-- local params = {
	-- 	method = "identify",
	-- 	distinctId = "thinkers"
	-- }
	local params = {}
	params["method"] = "identify"
	params["distinctId"] = distinctId
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.getDistinctId = function(callback)
	ThinkingAnalyticsAPI.getDistinctIdCallback = callback
	-- local params = {
	-- 	method = "getDistinctId"
	-- }
	local params = {}
	params["method"] = "getDistinctId"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.getDeviceId = function(callback)
	ThinkingAnalyticsAPI.getDeviceIdCallback = callback
	-- local params = {
	-- 	method = "getDeviceId"
	-- }
	local params = {}
	params["method"] = "getDeviceId"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.setSuperProperties = function(properties)
	-- local params = {
	-- 	method = "setSuperProperties",
	-- 	properties = {
	-- 		channel = "Apple Store",
	-- 		vip_level = 100
	-- 	}
	-- }
	local params = {}
	params["method"] = "setSuperProperties"
	params["properties"] = properties
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.unsetSuperProperties = function(property)
	-- local params = {
	-- 	method = "unsetSuperProperties",
	-- 	property = "channel"
	-- }
	local params = {}
	params["method"] = "unsetSuperProperties"
	params["property"] = property
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.getSuperProperties = function(callback)
	ThinkingAnalyticsAPI.getSuperPropertiesCallback = callback
	-- local params = {
	-- 	method = "getSuperProperties",
	-- }
	local params = {}
	params["method"] = "getSuperProperties"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.clearSuperProperties = function()
	-- local params = {
	-- 	method = "clearSuperProperties",
	-- }
	local params = {}
	params["method"] = "clearSuperProperties"
	local encoded = json.encode( params )
	ThinkingAnalyticsAPI.library.thinkingBridging( encoded )
end
ThinkingAnalyticsAPI.getPresetProperties = function(callback)
	ThinkingAnalyticsAPI.getPresetPropertiesCallback = callback
	-- local params = {
	-- 	method = "getPresetProperties",
	-- }
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