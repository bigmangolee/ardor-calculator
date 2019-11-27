package app.ardor.flutter.plugins;

import app.ardor.lib.utils.AppInfoUtils;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class AppInfoPlugins extends FlutterPluginsBase {

    @Override
    String getFlutterPluginChannel() {
        return "calculator.ardor.app/appinfo";
    }

    @Override
    void onMethodCall(MethodCall call, MethodChannel.Result result) {
        String type = call.argument("type");
        if (call.method.equals("singInfo")) {
            try {
                String retText = AppInfoUtils.getSingInfo(context, context.getPackageName(), type);
                result.success(retText);
            } catch (Exception e) {
                e.printStackTrace();
                result.error("AppInfo","error",e);
            }
        } else {
            result.notImplemented();
        }
    }
}
