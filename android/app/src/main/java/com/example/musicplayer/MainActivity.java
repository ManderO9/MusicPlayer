package com.example.musicplayer;

import io.flutter.embedding.android.FlutterActivity;

import androidx.core.app.ActivityCompat;

import android.content.pm.PackageManager;
import android.Manifest;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;

import android.widget.Toast;
import android.content.Intent;

public class MainActivity extends FlutterActivity {

    protected void onCreate(Bundle savedInstanceState) {
        this.RequestPermissions();
        super.onCreate(savedInstanceState);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "messages");
        Utils.Init(methodChannel);
        methodChannel.setMethodCallHandler(
            (call, result) -> {
                if (call.method.equals("StartService")) {
                    StartService();
                    result.success("OK");
                }
                if (call.method.equals("StopService")) {
                    StopService();
                    result.success("OK");
                }
            }
        );
    }


    private void StartService() {
        startService(new Intent(getApplicationContext(), MyService.class));
    }

    private void StopService() {
        stopService(new Intent(getApplicationContext(), MyService.class));
    }

    public void RequestPermissions() {
        int check = ActivityCompat.checkSelfPermission(getApplicationContext(),
                Manifest.permission.INTERNET);
        if (check != PackageManager.PERMISSION_GRANTED)
            requestPermissions(new String[]{Manifest.permission.INTERNET}, 1024);


        check = ActivityCompat.checkSelfPermission(getApplicationContext(),
                Manifest.permission.WRITE_EXTERNAL_STORAGE);
        if (check != PackageManager.PERMISSION_GRANTED)
            requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1024);

        check = ActivityCompat.checkSelfPermission(getApplicationContext(),
                Manifest.permission.READ_EXTERNAL_STORAGE);
        if (check != PackageManager.PERMISSION_GRANTED)
            requestPermissions(new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, 1024);


    }
}
