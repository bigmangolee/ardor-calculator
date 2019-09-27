package app.ardor.flutter.plugins;


import java.util.HashSet;

import io.flutter.plugin.common.BinaryMessenger;

public class FlutterPluginRegistrant {


    private static HashSet<Class<? extends FlutterPluginsBase>> pluginsContains = new HashSet<Class<? extends FlutterPluginsBase>>();

    public static void addPlugins(Class<? extends FlutterPluginsBase>  plugin) {
        pluginsContains.add(plugin);
    }

    public static void registerWith(BinaryMessenger messenger) {
        for (Class<? extends FlutterPluginsBase> plugin : pluginsContains) {
            try {
                FlutterPluginsBase flutterPlugin = plugin.newInstance();
                flutterPlugin.init(messenger);
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
    }
}
