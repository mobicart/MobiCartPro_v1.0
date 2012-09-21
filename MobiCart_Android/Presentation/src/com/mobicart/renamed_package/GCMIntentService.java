/**
 * 
 */
package com.mobicart.renamed_package;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import com.google.android.gcm.GCMBaseIntentService;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.constants.MobiCartConstantIds;


/**
 * @author mobicart
 *
 */
public class GCMIntentService extends GCMBaseIntentService {

	public static int count = 0;
	public GCMIntentService(){
		super(MobiCartConstantIds.GCM_SENDER_ID);
		
	}
		
	public void onRegistered(Context context, String regId) {
		sendRegistrationIdToServer(regId);
	}

	private void sendRegistrationIdToServer(String regID2) {
		String uri = createGCMUri(regID2);
		HttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(uri);
		StringBuilder sb = new StringBuilder();
		try {
			HttpResponse response = client.execute(post);
			BufferedReader rd = new BufferedReader(new InputStreamReader(
					response.getEntity().getContent()));

			String line = "";
			while ((line = rd.readLine()) != null) {
				sb.append(line + " \n");
			}
		} catch (ClientProtocolException e) {
		} catch (IOException e) {
		}
	}

	private String createGCMUri(String regID2) {
			
		String uri = "";
		uri = MobicartUrlConstants.baseGCMUrl + "user/"
				+ MobicartCommonData.appIdentifierObj.getAppId() + "/"
				+ regID2 +"/" + 0.0 + "/" + 0.0
				+ "/register?apptype=android";
		return uri;
	}
	public void onUnregistered(Context context, String regId) {
	}

	public void onMessage(Context context, Intent intent) {
		createNotification(context,intent.getStringExtra("title"),intent.getStringExtra("message"));
	}
	public void createNotification(Context context, String title, String message) {
		NotificationManager notificationManager = (NotificationManager) context
				.getSystemService(Context.NOTIFICATION_SERVICE);
		Notification notification = new Notification(R.drawable.mobicart_logo,
				message, System.currentTimeMillis());
		notification.flags |= Notification.FLAG_AUTO_CANCEL;
		Intent intent = new Intent(context, MessageReceivedActivity.class).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.putExtra("payload", message);
		int ukey = (int) System.currentTimeMillis();
 
		PendingIntent pendingIntent = PendingIntent.getActivity(context,ukey,
				intent, 0);
		
		notification.setLatestEventInfo(context, title, message,
				pendingIntent);
		notificationManager.notify(count++, notification);
	}
	public void onError(Context context, String errorId) {
	}
}
