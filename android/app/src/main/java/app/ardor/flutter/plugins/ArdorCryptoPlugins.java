package app.ardor.flutter.plugins;

import app.ardor.lib.crypto.TCrypto;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ArdorCryptoPlugins extends FlutterPluginsBase {

    @Override
    String getFlutterPluginChannel() {
        return "calculator.ardor.app/crypto";
    }

    @Override
    void onMethodCall(MethodCall call, MethodChannel.Result result) {
        String key = call.argument("key");
        String content = call.argument("content");
        if (call.method.equals("encrypt")) {
            try {
                String retText = TCrypto.encrypt(key,content);
                result.success(retText);
            } catch (Exception e) {
                e.printStackTrace();
                result.error("TCrypto.encrypt","error",e);
            }
        } else if (call.method.equals("decrypt")) {
            try {
                String retText = TCrypto.decrypt(key,content);
                result.success(retText);
            } catch (Exception e) {
                e.printStackTrace();
                result.error("TCrypto.decrypt","error",e);
            }
        } else {
            result.notImplemented();
        }
    }
}
