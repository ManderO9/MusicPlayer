package com.example.musicplayer;
import io.flutter.plugin.common.MethodChannel;

public class Utils {
    public static MethodChannel methodChannel;

    public static void Init(MethodChannel mc){
        methodChannel = mc;
    }

    public static void sendMethod(String methodName){
        methodChannel.invokeMethod(methodName, "any argument");
    }
}
