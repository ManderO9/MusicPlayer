package com.example.musicplayer;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.Context;

public class MyReceiver extends BroadcastReceiver{
    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        if (action.equals("PlayPause")) {
            Utils.sendMethod("PlayPause");
        }else if(action.equals("Next")){
            Utils.sendMethod("Next");
        }else if(action.equals("Previous")){
            Utils.sendMethod("Previous");
        }
    }
}