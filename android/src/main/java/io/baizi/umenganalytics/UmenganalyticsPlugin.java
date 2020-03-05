package io.baizi.umenganalytics;

import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.commonsdk.statistics.common.DeviceConfig;

import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * UmenganalyticsPlugin
 */
public class UmenganalyticsPlugin implements FlutterPlugin, MethodCallHandler {
    private static String CHANNEL_NAME = "io.baizi.umenganalytics";
    private Context context;

    private void setContext(Context context) {
        this.context = context;
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME);
        UmenganalyticsPlugin plugin = new UmenganalyticsPlugin();
        plugin.setContext(registrar.context());
        channel.setMethodCallHandler(plugin);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_NAME);
        UmenganalyticsPlugin plugin = new UmenganalyticsPlugin();
        plugin.setContext(flutterPluginBinding.getApplicationContext());
        channel.setMethodCallHandler(plugin);
    }

    public static String[] getTestDeviceInfo(Context context){
        String[] deviceInfo = new String[2];
        try {
            if(context != null){
                deviceInfo[0] = DeviceConfig.getDeviceIdForGeneral(context);
                deviceInfo[1] = DeviceConfig.getMac(context);
            }
        } catch (Exception e){
        }
        for(String s:deviceInfo) {
            Log.e("Umeng", s);
        }
        return deviceInfo;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "init":
                getTestDeviceInfo(context);
                initUmengAnalytics(call, result);
                break;
            case "onPageStart":
                onPageStart(call);
                break;
            case "onPageEnd":
                onPageEnd(call);
                break;
            case "onEvent":
                logEventObj(call);
                break;
            case "onError":
                reportError(call);
                break;
            default:
                result.notImplemented();
        }
    }

    /**
     * 初始化友盟统计
     *
     * @param call   call
     * @param result result
     */
    public void initUmengAnalytics(@NonNull MethodCall call, @NonNull Result result) {
        String appKey = (String) call.argument("androidKey");
        String channel = (String) call.argument("channel");
        Boolean logEnable = (Boolean) call.argument("logEnable");
        Boolean encrypt = (Boolean) call.argument("encrypt");
        Boolean reportCrash = (Boolean) call.argument("reportCrash");
        if (appKey == null || appKey.isEmpty()) {
            result.error("1", "请传入androidKey初始化友盟统计", null);
            return;
        }
        if (channel == null) {
            channel = "android";
        }
        UMConfigure.init(context, appKey, channel, UMConfigure.DEVICE_TYPE_PHONE, null);

        Log.d("UM", "initSetup: " + appKey);
        if (logEnable != null) {
            UMConfigure.setLogEnabled(logEnable);
        }
        if (encrypt != null) {
            UMConfigure.setEncryptEnabled(encrypt);
        }
        if (reportCrash != null) {
            MobclickAgent.setCatchUncaughtExceptions(reportCrash);
        }

        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            // 大于等于4.4选用AUTO页面采集模式
            MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.AUTO);
        } else {
            MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.MANUAL);
        }
        // 支持在子进程中统计自定义事件
        UMConfigure.setProcessEvent(true);

        result.success(true);
    }

    /**
     * 开始访问页面
     *
     * @param call methodcall
     */
    private void onPageStart(@NonNull MethodCall call) {
        String pageName = (String) call.arguments;
        if (pageName == null || pageName.isEmpty()) {
            return;
        }
        MobclickAgent.onPageStart(pageName);
    }

    /**
     * 结束访问页面
     *
     * @param call methodCall
     */
    private void onPageEnd(@NonNull MethodCall call) {
        String pageName = (String) call.arguments;
        if (pageName == null || pageName.isEmpty()) {
            return;
        }
        MobclickAgent.onPageEnd(pageName);
    }

    /**
     * 记录事件
     *
     * @param call method
     */
    private void logEventObj(@NonNull MethodCall call) {
        String event = call.argument("event");
        Map<String, Object> data = call.argument("data");
        if (event != null && data != null) {
            MobclickAgent.onEventObject(context, event, data);
        }
    }

    /**
     * 记录事件
     *
     * @param call method
     */
    private void logEvent(@NonNull MethodCall call) {

        MobclickAgent.onEvent(context, "play_music", "s1");
    }

    /**
     * 上报错误信息
     *
     * @param call methodCall
     */
    private void reportError(@NonNull MethodCall call) {

        String errorMessage = (String) call.arguments;
        if (errorMessage == null || errorMessage.isEmpty()) {
            return;
        }
        MobclickAgent.reportError(context, errorMessage);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
