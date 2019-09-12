package app.anise.flutter.plugins;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public abstract class FlutterPluginsBase {

    void init(BinaryMessenger messenger){
        new MethodChannel(messenger, getFlutterPluginChannel()).setMethodCallHandler(
                (call, result) -> FlutterPluginsBase.this.onMethodCall(call,result));
    }

    abstract String getFlutterPluginChannel();

    abstract void onMethodCall(MethodCall call, MethodChannel.Result result);
}
