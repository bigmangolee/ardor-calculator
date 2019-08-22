package app.anise.calculator;

import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  static final String FLUTTER_LOG_CHANNEL = "calculator.anise.app/app_log";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), FLUTTER_LOG_CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                  logPrint(call,result);
              }
            });
  }

    private void logPrint(MethodCall call,MethodChannel.Result result) {
      String tag = call.argument("tag");
      String msg = call.argument("msg");
        if (call.method.equals("logV")) {
            Log.v(tag, msg);
            result.success(0);
        } else if (call.method.equals("logD")) {
            Log.d(tag, msg);
            result.success(0);
        } else if (call.method.equals("logI")) {
            Log.i(tag, msg);
            result.success(0);
        } else if (call.method.equals("logW")) {
            Log.w(tag, msg);
            result.success(0);
        } else if (call.method.equals("logE")) {
            Log.e(tag, msg);
            result.success(0);
        } else {
            result.notImplemented();
        }
  }
}
