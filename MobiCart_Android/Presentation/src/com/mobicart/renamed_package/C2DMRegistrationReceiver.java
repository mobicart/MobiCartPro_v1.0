package com.mobicart.renamed_package;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.provider.Settings.Secure;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.core.NotificationRespone;
import com.mobicart.android.model.MobicartCommonData;

public class C2DMRegistrationReceiver extends BroadcastReceiver implements
		LocationListener {

	private Context context;
	@SuppressWarnings("unused")
	private String response;
	private String deviceId;

	@Override
	public void onReceive(Context context, Intent intent) {

		this.context = context;
		if (intent.getAction().equals(
				"com.google.android.c2dm.intent.REGISTRATION")) {
			final String registrationId = intent
					.getStringExtra("registration_id");
			if (registrationId != null) {
				deviceId = Secure.getString(context.getContentResolver(),
						Secure.ANDROID_ID);
				sendRegistrationIdToServer(deviceId, registrationId);
				saveRegistrationId(context, registrationId);
				NotificationRespone objNotificationResponse = new NotificationRespone();
				try {
					response = objNotificationResponse
							.getNotificationResponse(context);
				} catch (NullPointerException e) {
				} catch (JSONException e) {
				} catch (CustomException e) {
				}
			}
		}
	}

	/**
	 * Method is used to save registration ID to shared preferences.
	 * 
	 * @param context
	 * @param registrationId
	 */

	private void saveRegistrationId(Context context, String registrationId) {
		SharedPreferences prefs = PreferenceManager
				.getDefaultSharedPreferences(context);
		Editor edit = prefs.edit();
		edit.putString(SplashAct.AUTH, registrationId);
		edit.commit();
	}

	/**
	 * Method is used to save registration ID to Server.
	 * 
	 * @param deviceId
	 * @param registrationId
	 */
	public void sendRegistrationIdToServer(String deviceId,
			String registrationId) {
		String uri = createC2DMUri(deviceId, registrationId);
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

	/**
	 * Method is used to create URL by using fields App ID,registration
	 * ID,Longitude and Latitude.
	 * 
	 * @param deviceId
	 * @param registrationId
	 * @return
	 */
	public String createC2DMUri(String deviceId, String registrationId) {
		String uri = "";
		double latitude = 0;
		double longitude = 0;
		LocationManager locationManager = (LocationManager) context
				.getSystemService(Context.LOCATION_SERVICE);
		Criteria criteria = new Criteria();
		String provider = locationManager.getBestProvider(criteria, false);
		Location location = locationManager.getLastKnownLocation(provider);
		if (location != null) {
			latitude = (location.getLatitude());
			longitude = (location.getLongitude());
		} else {
		}
		uri = MobicartUrlConstants.baseC2DMUrl + "user/"
				+ MobicartCommonData.appIdentifierObj.getAppId() + "/"
				+ registrationId + "/" + longitude + "/" + latitude
				+ "/register?apptype=android";
		return uri;
	}

	@Override
	public void onLocationChanged(Location location) {
		location.getLatitude();
		location.getLongitude();
	}

	@Override
	public void onProviderDisabled(String provider) {

	}

	@Override
	public void onProviderEnabled(String provider) {

	}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras) {

	}
}
