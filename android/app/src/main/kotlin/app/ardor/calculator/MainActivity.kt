package app.ardor.calculator

import android.os.Bundle
import app.ardor.flutter.plugins.ArdorCryptoPlugins
import app.ardor.flutter.plugins.FlutterPluginRegistrant
import app.ardor.flutter.plugins.LogPlugins

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
      GeneratedPluginRegistrant.registerWith(this)
      FlutterPluginRegistrant.addPlugins(LogPlugins::class.java)
      FlutterPluginRegistrant.addPlugins(ArdorCryptoPlugins::class.java)
      FlutterPluginRegistrant.registerWith(this,this.flutterView)
  }
}
