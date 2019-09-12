package app.anise.calculator;

import android.os.Bundle;

import app.anise.flutter.plugins.FlutterPluginRegistrant;
import app.anise.flutter.plugins.LogPlugins;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    FlutterPluginRegistrant.addPlugins(LogPlugins.class);
    FlutterPluginRegistrant.registerWith(this.getFlutterView());
  }


}
