package com.example.musicplayer;

import static android.app.PendingIntent.FLAG_UPDATE_CURRENT;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.widget.Toast;
import android.content.IntentFilter;


import io.flutter.plugin.common.MethodChannel;

import androidx.core.app.NotificationCompat;


public class MyService extends Service {
    private MyReceiver receiver;


    public MyService() {
    }

    @Override
    public void onCreate() {
        receiver = new MyReceiver();
        registerReceiver(receiver, new IntentFilter("PlayPause"));
        registerReceiver(receiver, new IntentFilter("Next"));
        registerReceiver(receiver, new IntentFilter("Previous"));

        super.onCreate();
    }

    @Override
    public void onDestroy(){
        super.onDestroy();
        unregisterReceiver(receiver);
    }


    @Override
    public int onStartCommand(Intent startIntent, int flags, int startId) {
        //intent du clique notif
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0,
                notificationIntent, FLAG_UPDATE_CURRENT);

        // Notification Channel
        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        String channelId = "my_channel_id";
        CharSequence channelName = "My Channel";

        PendingIntent pauseIntent =
                PendingIntent.getBroadcast(this, 0, new Intent("PlayPause"), FLAG_UPDATE_CURRENT);
        PendingIntent nextIntent =
                PendingIntent.getBroadcast(this, 0, new Intent("Next"), FLAG_UPDATE_CURRENT);
        PendingIntent previousIntent =
                PendingIntent.getBroadcast(this, 0, new Intent("Previous"), FLAG_UPDATE_CURRENT);


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = new
                    NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_DEFAULT);
            notificationManager.createNotificationChannel(notificationChannel);
        }

        Notification notification =
                new NotificationCompat.Builder(this, channelId)
                        .setContentTitle("Lecture en cours")
                        .setContentText("Tahir ve Nafess")
                        .setSmallIcon(R.drawable.launch_background)
                        .setContentIntent(pendingIntent)
                        .addAction(R.drawable.launch_background, "Previous", previousIntent)
                        .addAction(R.drawable.launch_background, "Play/Pause", pauseIntent)
                        .addAction(R.drawable.launch_background, "Next", nextIntent)
                        // .setPriority(Notification.PRIORITY_MAX)
                        .build();
        startForeground(110, notification);
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        return null;
    }
}