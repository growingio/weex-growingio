package com.growingio.android.weex;

import android.text.TextUtils;
import android.widget.Toast;

import com.alibaba.weex.plugin.annotation.WeexModule;
import com.growingio.android.sdk.collection.GrowingIO;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

@WeexModule(name = "GrowingIO")
public class WeexGrowingioModule extends WXModule {
    private String trackPage = "";

    @JSMethod
    public void track(Map<String, Object> params, JSCallback callback) {
        if (params.size() == 0) {
            failCallback(callback, "[track]Argment can not be empty!");
            return ;
        }

        if (!params.containsKey("eventId")) {
            failCallback(callback, "[track] \"eventId\" do not exist!");
            return ;
        }
        if (!(params.get("eventId") instanceof String)) {
            failCallback(callback, "[track]The value of the key \"eventId\" must be String type!");
            return ;
        }
        if (!params.containsKey("number") && !params.containsKey("eventLevelVariable")) {
            GrowingIO.getInstance().track((String) params.get("eventId"));
        }

        if (params.containsKey("number")) {
            if (!(params.get("number") instanceof Number)) {
                failCallback(callback, "[track]The value of the key \"number\" must be Number type!");
                return ;
            }
            if (!params.containsKey("eventLevelVariable")) {
                GrowingIO.getInstance().track((String) params.get("eventId"), (Number) params.get("number"));
            } else {
                if (!(params.get("eventLevelVariable") instanceof JSONObject)) {
                    failCallback(callback, "[track]The value of the key \"eventLevelVariable\" must be JSONObject type!");
                    return ;
                }
                GrowingIO.getInstance().track((String) params.get("eventId"), (Number) params.get("number"), (JSONObject) params.get("eventLevelVariable"));
            }
        }

        if (params.containsKey("eventLevelVariable")) {
            if (!(params.get("eventLevelVariable") instanceof JSONObject)) {
                failCallback(callback, "[track]The value of the key \"eventLevelVariable\" must be JSONObject type!");
                return ;
            }
            GrowingIO.getInstance().track((String) params.get("eventId"), (JSONObject) params.get("eventLevelVariable"));
        }
    }

    @JSMethod
    public void page(String pageName, JSCallback callback) {
        if (TextUtils.isEmpty(pageName)) {
            failCallback(callback, "[page]Page name can not be empty!");
            return;
        }
        this.trackPage = pageName;
        GrowingIO.getInstance().trackPage(pageName);
    }

    @JSMethod
    public void setPageVariable(String pageName, Map<String, Object> pageLevelVariables, JSCallback callback) {
        if (TextUtils.isEmpty(pageName) || (!TextUtils.isEmpty(trackPage) && !pageName.equals(trackPage))) {
            failCallback(callback, "[setPageVariable]Page name can not be empty! or Need to call page first!");
            return;
        }
        JSONObject jsonObject = null;
        jsonObject = praseJsonObject(pageLevelVariables, callback);
        if (jsonObject == null)
            return;
        GrowingIO.getInstance().setPageVariable(pageName, jsonObject);
    }

    @JSMethod
    public void setEvar(Map<String, Object> conversionVariables, JSCallback callback) {
        JSONObject jsonObject = null;
        jsonObject = praseJsonObject(conversionVariables, callback);
        if (jsonObject == null)
            return;
        GrowingIO.getInstance().setEvar(jsonObject);
    }

    @JSMethod
    public void setPeopleVariable(Map<String, Object> peopleVariables, JSCallback callback) {
        JSONObject jsonObject = null;
        jsonObject = praseJsonObject(peopleVariables, callback);
        if (jsonObject == null)
            return;
        GrowingIO.getInstance().setPeopleVariable(jsonObject);
    }

    @JSMethod
    public void setUserId(String userId, JSCallback callback) {
        if (TextUtils.isEmpty(userId)) {
            failCallback(callback, "[setUserId]User Name can not be empty!");
            return ;
        }
        GrowingIO.getInstance().setUserId(userId);
    }

    @JSMethod
    public void clearUserId(JSCallback callback) {
        GrowingIO.getInstance().clearUserId();
    }

    public void successCallback(JSCallback callback, String msg) {
        callback.invoke("success: "+msg);
    }

    public void failCallback(JSCallback callback, String msg) {
        callback.invoke("fail: "+msg);
    }

    private JSONObject praseJsonObject(Map<String, Object> vars, JSCallback callback) {
        JSONObject jsonObject = new JSONObject();
        for (String key : vars.keySet()) {
            Object value = vars.get(key);
            try {
                jsonObject.putOpt(key, value);
            } catch (JSONException e) {
                failCallback(callback, e.getMessage());
                return null;
            }
        }
        return jsonObject;
    }

    @JSMethod (uiThread = true)
    public void printLog(String msg) {
        Toast.makeText(mWXSDKInstance.getContext(),msg,Toast.LENGTH_SHORT).show();
    }
}