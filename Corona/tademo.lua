tademo = {}

local json = require( "json" )
local ThinkingAnalyticsAPI = require("ThinkingAnalyticsAPI")

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
    	"setSuperProperties", "unsetSuperProperties", "getSuperProperties", "clearSuperProperties", "getPresetProperties" 
    }
    for i = 1,(#eventList) do
    	local diff = 60
    	if i%2==1 then
    		diff = -60
    	end
    	local eventText = display.newText( eventList[i], display.contentCenterX+diff, 30*(((i-1)-((i-1)%2))/2)+60, native.systemFont, 14 )
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

tademo.shareInstance = function ()
    local params = {
        appId = "22e445595b0f42bd8c5fe35bc44b88d6",
        serverUrl = "https://receiver-ta-dev.thinkingdata.cn",
        enableLog = true,
        -- debugMode = "normal",  -- normal, debug, debugOnly
        -- autoTrack = {
        -- 	"appStart", "appEnd", "appInstall"
        -- }
    }
    ThinkingAnalyticsAPI.shareInstance( params )
end
tademo.track = function ()    
    ThinkingAnalyticsAPI.track( "TA" )
    -- ThinkingAnalyticsAPI.track( "TA", { 
    --     key_1 = "value_1" 
    -- } )
end
tademo.trackFirst = function ()
    ThinkingAnalyticsAPI.trackFirst( "FirstEvent", { 
        key_1 = "value_1" 
    } )
    -- ThinkingAnalyticsAPI.trackFirst( "FirstEvent", { 
    --     key_1 = "value_1" 
    -- }, "FirstEventId" )
end
tademo.trackUpdate = function ()
    ThinkingAnalyticsAPI.trackUpdate( "UpdateEvent", { 
        key_1 = "value_1" 
    }, "UpdateEventId" )
end
tademo.trackOverwrite = function () 
    ThinkingAnalyticsAPI.trackOverwrite( "OverwriteEvent", { 
        key_1 = "value_1" 
    }, "OverwriteEventId" )
end
tademo.timeEvent = function ()
    ThinkingAnalyticsAPI.timeEvent( "TA" )
end
tademo.userSet = function ()    
    ThinkingAnalyticsAPI.userSet( { 
        name = "Tiki",
        age = 20
    } )
end
tademo.userSetOnce = function ()
    ThinkingAnalyticsAPI.userSetOnce( { 
        gender = "male"
    } )
end
tademo.userUnset = function ()
    ThinkingAnalyticsAPI.userUnset( "name" )
end
tademo.userAdd = function ()
    ThinkingAnalyticsAPI.userAdd( { 
        age = 1
    } )
end
tademo.userAppend = function ()
    ThinkingAnalyticsAPI.userAppend( { 
        toys = { "ball" }
    } )
end
tademo.userUniqAppend = function ()
    ThinkingAnalyticsAPI.userUniqAppend( { 
        toys = { "ball", "apple" }
    } )
end
tademo.userDel = function ()
    ThinkingAnalyticsAPI.userDel()
end
tademo.flush = function ()
    ThinkingAnalyticsAPI.flush()
end
tademo.login = function ()
    ThinkingAnalyticsAPI.login( "136" )
end
tademo.logout = function ()
    ThinkingAnalyticsAPI.logout()
end
tademo.identify = function ()
    ThinkingAnalyticsAPI.identify( "thinkers" )
end
tademo.getDistinctId = function ()
    ThinkingAnalyticsAPI.getDistinctId( function (ret)
        print( "@Corona: distinctId = " .. ret )
    end )
end
tademo.getDeviceId = function ()
    ThinkingAnalyticsAPI.getDeviceId( function (ret)
        print( "@Corona: deviceId = " .. ret )
    end )
end
tademo.setSuperProperties = function ()
    ThinkingAnalyticsAPI.setSuperProperties( {
        channel = "Apple Store",
        vip_level = 100
    } )
end
tademo.unsetSuperProperties = function ()
    ThinkingAnalyticsAPI.unsetSuperProperties( "vip_level" )
end
tademo.getSuperProperties = function ()
    ThinkingAnalyticsAPI.getSuperProperties( function (ret)
        print( "@Corona: superProperties = " .. tademo.tableString(ret) )
    end )
end
tademo.clearSuperProperties = function ()
    ThinkingAnalyticsAPI.clearSuperProperties()
end
tademo.getPresetProperties = function ()
    ThinkingAnalyticsAPI.getPresetProperties( function (ret)
        print( "@Corona: presetProperties = " .. tademo.tableString(ret) )
    end )
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