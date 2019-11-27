package app.ardor.flutter.plugins;

import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public abstract class FlutterPluginsBase {
    protected Context context;
    void init(Context context,BinaryMessenger messenger){
        this.context = context;
        new MethodChannel(messenger, getFlutterPluginChannel()).setMethodCallHandler(
                (call, result) -> FlutterPluginsBase.this.onMethodCall(call,result));
    }

    abstract String getFlutterPluginChannel();

    abstract void onMethodCall(MethodCall call, MethodChannel.Result result);
}
