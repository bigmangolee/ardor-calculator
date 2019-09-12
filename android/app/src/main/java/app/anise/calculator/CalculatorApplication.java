package app.anise.calculator;

import app.anise.lib.store.StorageManager;
import io.flutter.app.FlutterApplication;

public class CalculatorApplication extends FlutterApplication {

    public void onCreate() {
        super.onCreate();
        StorageManager.getInstance().init(this);
    }
}
