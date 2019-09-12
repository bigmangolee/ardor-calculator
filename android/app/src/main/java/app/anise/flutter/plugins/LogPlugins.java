package app.anise.flutter.plugins;


import app.anise.lib.utils.AppLog;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class LogPlugins extends FlutterPluginsBase{

    @Override
    String getFlutterPluginChannel() {
        return "calculator.anise.app/app_log";
    }

    @Override
    void onMethodCall(MethodCall call, MethodChannel.Result result) {
        logPrint(call,result);
    }

    private void logPrint(MethodCall call,MethodChannel.Result result) {
        String tag = call.argument("tag");
        String msg = call.argument("msg");
        if (call.method.equals("logV")) {
            AppLog.v(tag, msg);
            result.success(0);
        } else if (call.method.equals("logD")) {
            AppLog.d(tag, msg);
            result.success(0);
        } else if (call.method.equals("logI")) {
            AppLog.i(tag, msg);
            result.success(0);
        } else if (call.method.equals("logW")) {
            AppLog.w(tag, msg);
            result.success(0);
        } else if (call.method.equals("logE")) {
            AppLog.e(tag, msg);
            result.success(0);
        } else {
            result.notImplemented();
        }
    }
}
