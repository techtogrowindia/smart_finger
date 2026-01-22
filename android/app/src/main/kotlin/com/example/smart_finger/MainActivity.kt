package com.techtogrow.smartfingerstechnician

import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        createNewComplaintChannel()
    }

    private fun createNewComplaintChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            val channelId = "new_complaint_channel"
            val channelName = "New Complaint Assigned"
            val channelDescription = "Notifications for new complaints"

            val soundUri = Uri.parse(
                "android.resource://${applicationContext.packageName}/raw/notification"
            )

            val audioAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()

            val channel = NotificationChannel(
                channelId,
                channelName,
                NotificationManager.IMPORTANCE_HIGH
            )

            channel.description = channelDescription
            channel.setSound(soundUri, audioAttributes)
            channel.enableVibration(true)
            channel.enableLights(true)

            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }
}
