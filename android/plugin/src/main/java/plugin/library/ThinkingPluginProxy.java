package plugin.library;

import android.content.Context;
import android.text.TextUtils;

import com.ansca.corona.CoronaEnvironment;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import cn.thinkingdata.analytics.TDConfig;
import cn.thinkingdata.analytics.TDFirstEvent;
import cn.thinkingdata.analytics.TDOverWritableEvent;
import cn.thinkingdata.analytics.TDUpdatableEvent;
import cn.thinkingdata.analytics.ThinkingAnalyticsSDK;

public class ThinkingPluginProxy {

    private static Context ceContext = CoronaEnvironment.getApplicationContext();

    private static String defaultAppId;

    public static void setCustomerLibInfo(JSONObject params) {
        String libName = params.optString("libName");
        String libVersion = params.optString("libVersion");
        ThinkingAnalyticsSDK.setCustomerLibInfo(libName, libVersion);
    }

    public static void shareInstance(JSONObject params) {
        String appId = params.optString("appId");
        String serverUrl = params.optString("serverUrl");
        String debugMode = params.optString("debugMode");
        boolean enableLog = params.optBoolean("enableLog");
        JSONArray autoTrack = params.optJSONArray("autoTrack");

        if (TextUtils.isEmpty(defaultAppId)) {
            defaultAppId = appId;
        }

        ThinkingAnalyticsSDK.enableTrackLog(enableLog);

        TDConfig config = TDConfig.getInstance(ceContext, appId, serverUrl);
        if (debugMode.equals("debug")) {
            config.setMode(TDConfig.ModeEnum.DEBUG);
        } else if (debugMode.equals("debugOnly")) {
            config.setMode(TDConfig.ModeEnum.DEBUG_ONLY);
        } else  {
            config.setMode(TDConfig.ModeEnum.NORMAL);
        }
        List<ThinkingAnalyticsSDK.AutoTrackEventType> autoTrackType = new ArrayList<>();
        for(int i=0; autoTrack!=null&&i<autoTrack.length(); i++) {
            String type = autoTrack.optString(i);
            if ("appInstall".equals(type)) {
                autoTrackType.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_INSTALL);
            } else if ("appStart".equals(type)) {
                autoTrackType.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_START);
            } else if ("appEnd".equals(type)) {
                autoTrackType.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_END);
            }
        }
        ThinkingAnalyticsSDK.sharedInstance(config);
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).enableAutoTrack(autoTrackType);
    }

    public static void track(JSONObject params) {
        String appId = params.optString("appId");
        String eventName = params.optString("eventName");
        JSONObject properties = params.optJSONObject("properties");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).track(eventName, properties);
    }

    public static void trackFirst(JSONObject params) {
        String appId = params.optString("appId");
        String eventName = params.optString("eventName");
        String eventId = params.optString("eventId");
        JSONObject properties = params.optJSONObject("properties");
        TDFirstEvent firstEvent = new TDFirstEvent(eventName, properties);
        if (eventId != null) {
            firstEvent.setFirstCheckId(eventId);
        }
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).track(firstEvent);
    }

    public static void trackUpdate(JSONObject params) {
        String appId = params.optString("appId");
        String eventName = params.optString("eventName");
        String eventId = params.optString("eventId");
        JSONObject properties = params.optJSONObject("properties");
        TDUpdatableEvent updatableEvent = new TDUpdatableEvent(eventName, properties, eventId);
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).track(updatableEvent);
    }

    public static void trackOverwrite(JSONObject params) {
        String appId = params.optString("appId");
        String eventName = params.optString("eventName");
        String eventId = params.optString("eventId");
        JSONObject properties = params.optJSONObject("properties");
        TDOverWritableEvent overWritableEvent = new TDOverWritableEvent(eventName, properties, eventId);
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).track(overWritableEvent);
    }

    public static void timeEvent(JSONObject params) {
        String appId = params.optString("appId");
        String eventName = params.optString("eventName");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).timeEvent(eventName);
    }

    public static void userSet(JSONObject params) {
        String appId = params.optString("appId");
        JSONObject properties = params.optJSONObject("properties");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).user_set(properties);
    }

    public static void userSetOnce(JSONObject params) {
        String appId = params.optString("appId");
        JSONObject properties = params.optJSONObject("properties");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).user_setOnce(properties);
    }

    public static void userUnset(JSONObject params) {
        String appId = params.optString("appId");
        String property = params.optString("property");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).user_unset(property);
    }

    public static void userAdd(JSONObject params) {
        String appId = params.optString("appId");
        JSONObject properties = params.optJSONObject("properties");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).user_add(properties);
    }

    public static void userAppend(JSONObject params) {
        String appId = params.optString("appId");
        JSONObject properties = params.optJSONObject("properties");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).user_append(properties);
    }

    public static void userUniqAppend(JSONObject params) {
        String appId = params.optString("appId");
        JSONObject properties = params.optJSONObject("properties");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).user_uniqAppend(properties);
    }

    public static void userDel(JSONObject params) {
        String appId = params.optString("appId");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).user_delete();
    }

    public static void flush(JSONObject params) {
        String appId = params.optString("appId");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).flush();
    }

    public static void login(JSONObject params) {
        String appId = params.optString("appId");
        String accountId = params.optString("accountId");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).login(accountId);
    }

    public static void logout(JSONObject params) {
        String appId = params.optString("appId");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).logout();
    }

    public static void identify(JSONObject params) {
        String appId = params.optString("appId");
        String distinctId = params.optString("distinctId");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).identify(distinctId);
    }

    public static JSONObject getDistinctId(JSONObject params) {
        String appId = params.optString("appId");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        String distinctId = ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).getDistinctId();
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("type", "getDistinctId");
            jsonObject.put("message", new JSONObject().put("distinctId", distinctId));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    public static JSONObject getDeviceId(JSONObject params) {
        String appId = params.optString("appId");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        String deviceId = ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).getDeviceId();
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("type", "getDeviceId");
            jsonObject.put("message", new JSONObject().put("deviceId", deviceId));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    public static void setSuperProperties(JSONObject params) {
        String appId = params.optString("appId");
        JSONObject properties = params.optJSONObject("properties");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).setSuperProperties(properties);
    }

    public static void unsetSuperProperties(JSONObject params) {
        String appId = params.optString("appId");
        String property = params.optString("property");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).unsetSuperProperty(property);
    }

    public static JSONObject getSuperProperties(JSONObject params) {
        String appId = params.optString("appId");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        JSONObject properties = ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).getSuperProperties();
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("type", "getSuperProperties");
            jsonObject.put("message", new JSONObject().put("properties", properties));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    public static void clearSuperProperties(JSONObject params) {
        String appId = params.optString("appId");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).clearSuperProperties();
    }

    public static JSONObject getPresetProperties(JSONObject params) {
        String appId = params.optString("appId");
        if (TextUtils.isEmpty(appId)) {
            appId = defaultAppId;
        }
        JSONObject properties = ThinkingAnalyticsSDK.sharedInstance(ceContext, appId).getPresetProperties().toEventPresetProperties();
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("type", "getPresetProperties");
            jsonObject.put("message", new JSONObject().put("properties", properties));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    public static void calibrateTime(JSONObject params) {
        long timestamp = params.optLong("timestamp");
        ThinkingAnalyticsSDK.calibrateTime(timestamp);
    }

    public static void calibrateTimeWithNtp(JSONObject params) {
        String ntpServer = params.optString("ntpServer");
        ThinkingAnalyticsSDK.calibrateTimeWithNtp(ntpServer);
    }
}
