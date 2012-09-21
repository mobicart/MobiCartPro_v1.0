package com.mobicart.renamed_package;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class C2DMMessageReceiver extends BroadcastReceiver {
	public static int count = 0;

	@Override
	public void onReceive(Context context, Intent intent) {
		if (intent.getAction().equals("com.google.android.c2dm.intent.RECEIVE")) {
			final String payload = intent.getStringExtra("payload");
			createNotification(context, payload);
		}
	}

	/**
	 * This Method is used to create notification for user after receiving message From C2DM server.
	 * @param context
	 * @param payload
	 */
	public void createNotification(Context context, String payload) {
		NotificationManager notificationManager = (NotificationManager) context
				.getSystemService(Context.NOTIFICATION_SERVICE);
		Notification notification = new Notification(R.drawable.mobicart_logo,
				payload, System.currentTimeMillis());
		notification.flags |= Notification.FLAG_AUTO_CANCEL;
		Intent intent = new Intent(context, MessageReceivedActivity.class);
		intent.putExtra("payload", payload);
		PendingIntent pendingIntent = PendingIntent.getActivity(context, 0,
				intent, 0);
		notification.setLatestEventInfo(context, "Message", payload,
				pendingIntent);
		notificationManager.notify(count++, notification);
	}
}
