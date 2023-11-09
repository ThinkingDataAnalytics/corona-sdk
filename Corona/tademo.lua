tademo = {}

local json = require( "json" )
local TDAnalytics = require("TDAnalytics")

tademo.startRun = function ()
    tademo.loadUIElements()
end

tademo.loadUIElements = function ()
    local eventList = 
    { 
    	"shareInstance", 
    	"track", "trackFirst", "trackUpdate", "trackOverwrite", "timeEvent", 
    	"userSet", "userSetOnce", "userUnset", "userAdd", "userAppend", "userUniqAppend", "userDel", 
    	"flush", "login", "logout", "identify", "getDistinctId", "getDeviceId", 
    	"setSuperProperties", "unsetSuperProperties", "getSuperProperties", "clearSuperProperties", "getPresetProperties",
        "calibrateTime", "calibrateTimeWithNtp"
    }
    for i = 1,(#eventList) do
    	local diff = 60
    	if i%2==1 then
    		diff = -60
    	end
    	local eventText = display.newText( eventList[i], display.contentCenterX+diff, 30*(((i-1)-((i-1)%2))/2)+100, native.systemFont, 14 )
    	eventText:setFillColor( 0.3, 0.3, 0.3 )
    	eventText:addEventListener( "tap", function ()
    		local funcName = eventList[i]
            local f = loadstring("tademo."..funcName.."()");
    		if type( f ) == "function" then
                f()
    		else
    			print( "@Corona " .. funcName .. " is not function" )
    		end
    	end )
    end
end

local _appId_1 = "22e445595b0f42bd8c5fe35bc44b88d6"
local _serverUrl_1 = "https://receiver-ta-dev.thinkingdata.cn"

local _appId_2 = "debug-appid"
local _serverUrl_2 = "https://receiver-ta-dev.thinkingdata.cn"

tademo.shareInstance = function ()
    local params = {
        appId = _appId_1,
        serverUrl = _serverUrl_1,
        enableLog = true --,
        -- debugMode = "normal",  -- normal, debug, debugOnly
        -- autoTrack = {
        -- 	"appStart", "appEnd", "appInstall"
        -- }
    }
    TDAnalytics.init( params )

    local params_2 = {
        appId = _appId_2,
        serverUrl = _serverUrl_2,
        enableLog = true
        -- debugMode = "normal",  -- normal, debug, debugOnly
        -- autoTrack = {
        -- 	"appStart", "appEnd", "appInstall"
        -- }
    }
    TDAnalytics.init( params_2 )
end
tademo.track = function ()    
    TDAnalytics.track( "TA", { key_1 = "value_1" } )
    TDAnalytics.track( "TA", { key_2 = "value_2" }, _appId_2)
end
tademo.trackFirst = function ()
    TDAnalytics.trackFirst( "FirstEvent", { 
        key_1 = "value_1" 
    })
    TDAnalytics.trackFirst( "FirstEvent", { 
        key_2 = "value_2" 
    }, "FirstEventId_2", _appId_2 )
end
tademo.trackUpdate = function ()
    TDAnalytics.trackUpdate( "UpdateEvent", { 
        key_1 = "value_1" 
    }, "UpdateEventId_1" )
    TDAnalytics.trackUpdate( "UpdateEvent", { 
        key_2 = "value_2" 
    }, "UpdateEventId_2", _appId_2 )
end
tademo.trackOverwrite = function () 
    TDAnalytics.trackOverwrite( "OverwriteEvent", { 
        key_1 = "value_1" 
    }, "OverwriteEventId_1" )
    TDAnalytics.trackOverwrite( "OverwriteEvent", { 
        key_2 = "value_2" 
    }, "OverwriteEventId_2", _appId_2 )
end
tademo.timeEvent = function ()
    TDAnalytics.timeEvent( "TA" )
    TDAnalytics.timeEvent( "TA", _appId_2 )
end
tademo.userSet = function ()    
    TDAnalytics.userSet( { 
        name = "Tiki_1",
        age = 20
    } )
    TDAnalytics.userSet( { 
        name = "Tiki_2",
        age = 20
    }, _appId_2 )
end
tademo.userSetOnce = function ()
    TDAnalytics.userSetOnce( { 
        gender = "male_1"
    } )
    TDAnalytics.userSetOnce( { 
        gender = "male_2"
    }, _appId_2 )
end
tademo.userUnset = function ()
    TDAnalytics.userUnset( "name_1" )
    TDAnalytics.userUnset( "name_2", _appId_2 )
end
tademo.userAdd = function ()
    TDAnalytics.userAdd( { 
        age = 1
    } )
    TDAnalytics.userAdd( { 
        age = 2
    }, _appId_2 )
end
tademo.userAppend = function ()
    TDAnalytics.userAppend( { 
        toys = { "ball_1" }
    } )
    TDAnalytics.userAppend( { 
        toys = { "ball_2" }
    }, _appId_2 )
end
tademo.userUniqAppend = function ()
    TDAnalytics.userUniqAppend( { 
        toys = { "ball_1", "apple_1" }
    } )
    TDAnalytics.userUniqAppend( { 
        toys = { "ball_2", "apple_2" }
    }, _appId_2 )
end
tademo.userDel = function ()
    TDAnalytics.userDelete()
    TDAnalytics.userDelete(_appId_2)
end
tademo.flush = function ()
    TDAnalytics.flush()
    TDAnalytics.flush(_appId_2)
end
tademo.login = function ()
    TDAnalytics.login( "136" )
    TDAnalytics.login( "236", _appId_2 )
end
tademo.logout = function ()
    TDAnalytics.logout()
    TDAnalytics.logout(_appId_2)
end
tademo.identify = function ()
    TDAnalytics.setDistinctId( "thinkers_1" )
    TDAnalytics.setDistinctId( "thinkers_2", _appId_2 )
end
tademo.getDistinctId = function ()
    TDAnalytics.getDistinctId( function (ret)
        print( "@Corona: distinctId_1 = " .. ret )
    end )
    TDAnalytics.getDistinctId( function (ret)
        print( "@Corona: distinctId_2 = " .. ret )
    end, _appId_2 )
end
tademo.getDeviceId = function ()
    TDAnalytics.getDeviceId( function (ret)
        print( "@Corona: deviceId_1 = " .. ret )
    end )
    TDAnalytics.getDeviceId( function (ret)
        print( "@Corona: deviceId_2 = " .. ret )
    end, _appId_2 )
end
tademo.setSuperProperties = function ()
    TDAnalytics.setSuperProperties( {
        channel = "Apple Store 1",
        vip_level = 100
    } )
    TDAnalytics.setSuperProperties( {
        channel = "Apple Store 2",
        vip_level = 200
    }, _appId_2 )
end
tademo.unsetSuperProperties = function ()
    TDAnalytics.unsetSuperProperties( "vip_level" )
    TDAnalytics.unsetSuperProperties( "vip_level", _appId_2 )
end
tademo.getSuperProperties = function ()
    TDAnalytics.getSuperProperties( function (ret)
        print( "@Corona: superProperties_1 = " .. tademo.tableString(ret) )
    end )
    TDAnalytics.getSuperProperties( function (ret)
        print( "@Corona: superProperties_2 = " .. tademo.tableString(ret) )
    end, _appId_2 )
end
tademo.clearSuperProperties = function ()
    TDAnalytics.clearSuperProperties()
    TDAnalytics.clearSuperProperties(_appId_2)
end
tademo.getPresetProperties = function ()
    TDAnalytics.getPresetProperties( function (ret)
        print( "@Corona: presetProperties_1 = " .. tademo.tableString(ret) )
    end )
    TDAnalytics.getPresetProperties( function (ret)
        print( "@Corona: presetProperties_2 = " .. tademo.tableString(ret) )
    end, _appId_2 )
end

tademo.calibrateTime = function ()
    TDAnalytics.calibrateTime(1672502400000)
end

tademo.calibrateTimeWithNtp = function ()
    TDAnalytics.calibrateTimeWithNtp("time.apple.com")
end


tademo.tableString = function(tab)
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

return tademo