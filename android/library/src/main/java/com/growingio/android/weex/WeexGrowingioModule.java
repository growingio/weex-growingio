package com.growingio.android.weex;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.weex.plugin.annotation.WeexModule;
import com.growingio.android.sdk.collection.GrowingIO;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

import org.json.JSONException;

import java.util.Map;

@WeexModule(name = "GrowingIO")
public class WeexGrowingioModule extends WXModule {
    private static final String TAG = "GrowingIOWeex";

    private String trackPage = "";

    @JSMethod
    public void track(@Nullable Map<String, Object> params) {
        JSCallback callback = null;
        if (isEmpty(params)) {
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

        Object eventLevelVariable = params.get("eventLevelVariable");
        if (params.containsKey("number")) {
            if (!(params.get("number") instanceof Number)) {
                failCallback(callback, "[track]The value of the key \"number\" must be Number type!");
                return ;
            }
            if (eventLevelVariable == null) {
                GrowingIO.getInstance().track((String) params.get("eventId"), (Number) params.get("number"));
            } else {
                if (!(eventLevelVariable instanceof JSONObject)) {
                    failCallback(callback, "[track]The value of the key \"eventLevelVariable\" must be JSONObject type!");
                    return ;
                }
                GrowingIO.getInstance().track((String) params.get("eventId"), (Number) params.get("number"), toOrgJSONObject((JSONObject) eventLevelVariable));
            }
        }

        if (eventLevelVariable != null) {
            if (!(eventLevelVariable instanceof JSONObject)) {
                failCallback(callback, "[track]The value of the key \"eventLevelVariable\" must be JSONObject type!");
                return ;
            }
            GrowingIO.getInstance().track((String) params.get("eventId"), toOrgJSONObject((JSONObject)eventLevelVariable));
        }
    }

    //@JSMethod
    public void page(@Nullable String pageName) {
        JSCallback callback = null;
        if (TextUtils.isEmpty(pageName)) {
            failCallback(callback, "[page]Page name can not be empty!");
            return;
        }
        this.trackPage = pageName;
        GrowingIO.getInstance().trackPage(pageName);
    }

    //@JSMethod
    public void setPageVariable(@Nullable String pageName, @Nullable Map<String, Object> pageLevelVariables) {
        JSCallback callback = null;
        if (TextUtils.isEmpty(pageName) || (!TextUtils.isEmpty(trackPage) && !pageName.equals(trackPage))) {
            failCallback(callback, "[setPageVariable]Page name can not be empty! or Need to call page first!");
            return;
        }
        org.json.JSONObject jsonObject = praseJsonObject(pageLevelVariables, callback);
        if (jsonObject == null)
            return;
        GrowingIO.getInstance().setPageVariable(pageName, jsonObject);
    }

    @JSMethod
    public void setEvar(@Nullable Map<String, Object> conversionVariables) {
        JSCallback callback = null;
        org.json.JSONObject jsonObject = praseJsonObject(conversionVariables, callback);
        if (jsonObject == null)
            return;
        GrowingIO.getInstance().setEvar(jsonObject);
    }

    @JSMethod
    public void setPeopleVariable(@Nullable Map<String, Object> peopleVariables) {
        JSCallback callback = null;
        org.json.JSONObject jsonObject = praseJsonObject(peopleVariables, callback);
        if (jsonObject == null)
            return;
        GrowingIO.getInstance().setPeopleVariable(jsonObject);
    }

    @JSMethod
    public void setUserId(@Nullable String userId) {
        JSCallback callback = null;
        if (TextUtils.isEmpty(userId)) {
            failCallback(callback, "[setUserId]User Name can not be empty!");
            return ;
        }
        GrowingIO.getInstance().setUserId(userId);
    }

    @JSMethod
    public void clearUserId(@Nullable JSCallback callback) {
        GrowingIO.getInstance().clearUserId();
    }

    public void successCallback(@Nullable JSCallback callback, String msg) {
        if (callback != null){
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("result", "success");
            jsonObject.put("info", msg);
            callback.invoke(jsonObject);
        }
    }

    public void failCallback(@Nullable JSCallback callback, String msg) {
        if (callback != null){
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("result", "error");
            jsonObject.put("info", msg);
            callback.invoke(jsonObject);
        }
        Log.e(TAG, "failed: " + msg);
    }

    /**
     * 将aliJson转化为 Org的JSONObject
     */
    @Nullable
    static org.json.JSONObject toOrgJSONObject(com.alibaba.fastjson.JSONObject aliJson){
        if (aliJson == null) return null;
        String jsonString = aliJson.toJSONString();
        try {
            return new org.json.JSONObject(jsonString);
        } catch (JSONException e) {
            return null;
        }
    }

    private boolean isEmpty(Map<?, ?> map){
        return map == null || map.isEmpty();
    }

    private org.json.JSONObject praseJsonObject(Map<String, Object> vars, JSCallback callback) {
        org.json.JSONObject jsonObject = new org.json.JSONObject();
        if (isEmpty(vars))
            return jsonObject;
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
