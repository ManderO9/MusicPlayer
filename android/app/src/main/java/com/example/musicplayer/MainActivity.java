package com.example.musicplayer;

import io.flutter.embedding.android.FlutterActivity;

import androidx.core.app.ActivityCompat;

import android.content.pm.PackageManager;

import android.Manifest;
import android.os.Bundle;

public class MainActivity extends FlutterActivity {
    protected void onCreate(Bundle savedInstanceState) {
        this.RequestPermissions();
        super.onCreate(savedInstanceState);
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
