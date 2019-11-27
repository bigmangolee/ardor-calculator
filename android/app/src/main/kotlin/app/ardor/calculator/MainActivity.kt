package app.ardor.calculator

import android.os.Bundle
import app.ardor.flutter.plugins.AppInfoPlugins
import app.ardor.flutter.plugins.ArdorCryptoPlugins
import app.ardor.flutter.plugins.FlutterPluginRegistrant
import app.ardor.flutter.plugins.LogPlugins
import app.ardor.lib.crypto.AES
import app.ardor.lib.utils.AppInfoUtils

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
      AES.setIvParameterSpec(AppInfoUtils.getSingInfo(applicationContext, packageName, AppInfoUtils.SHA1))
      GeneratedPluginRegistrant.registerWith(this)
      FlutterPluginRegistrant.addPlugins(LogPlugins::class.java)
      FlutterPluginRegistrant.addPlugins(ArdorCryptoPlugins::class.java)
      FlutterPluginRegistrant.addPlugins(AppInfoPlugins::class.java)
      FlutterPluginRegistrant.registerWith(this,this.flutterView)
  }
}
