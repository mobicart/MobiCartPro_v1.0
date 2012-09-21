package com.mobicart.renamed_package;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.View;
import com.bugsense.trace.BugSenseHandler;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.communication.Oauth;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.constants.MobiCartConstantIds;
import com.mobicart.renamed_package.utils.AsyncTasks.GetAppIdentifierTask;

/**
 * This activity is the launcher activity for the app. In this activity, all the
 * initial "application data" gets downloaded through the tasks.
 * 
 * @author mobicart
 * 
 */
public class SplashAct extends Activity {

	private static final int LDPI = 3;
	private static final int MDPI = 4;
	private static final int HDPI = 6;
	public static final int XHDPI = 6;
	public static boolean xhdpi=false;
	private View backgroundView;
	public static boolean LANG_PAKG_HIT_MODE = false;
	public final static String AUTH = "authentication";
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		BugSenseHandler.setup(this, "5b625fc4");
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
		getAppKey();
		chkScreenResolution();
		backgroundView = new View(this);
		MobicartCommonData.keyValues = this.getSharedPreferences("KeyValue",
				Context.MODE_PRIVATE);
		backgroundView.setBackgroundDrawable(getSplashImage());
		setContentView(backgroundView);
	}

	private void getAppKey() {
		InputStream in = null;
		String[] keyText = null;
		try {
			in = getResources().openRawResource(R.raw.key);
			BufferedReader reader = new BufferedReader(
					new InputStreamReader(in));

			String line = null;
			try {
				line = reader.readLine();
				keyText = line.split("#");
				Oauth.consumerKey = keyText[1];
				Oauth.consumerSecret = keyText[2];
			} catch (IOException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), "key file I/O exception");
			}
			try {
				MobiCartConstantIds.GCM_SENDER_ID = keyText[4];
				MobiCartConstantIds.GCM_API_KEY = keyText[5];
			} catch (Exception e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), "key file I/O exception");
			}
			try {
				MobiCartConstantIds.NOTIFICATION_SENDER_ID = keyText[10];
			} catch (Exception e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), "key file I/O exception");
			}
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					objMobicartLogger.LogExceptionMsg(reqDateFormat
							.format(new Date()), "key file I/O exception");
				}
			}
		}
	}

	private void chkScreenResolution() {
		DisplayMetrics dm = getResources().getDisplayMetrics();
		switch (dm.densityDpi) {
		case DisplayMetrics.DENSITY_HIGH:
			MobicartUrlConstants.resolution = HDPI;
			xhdpi=false;
			break;
		case DisplayMetrics.DENSITY_MEDIUM:
			MobicartUrlConstants.resolution = MDPI;
			break;
		case DisplayMetrics.DENSITY_LOW:
			MobicartUrlConstants.resolution = LDPI;
			break;
		default:{
			MobicartUrlConstants.resolution = XHDPI;
			xhdpi=true;
		}
		}
	}

	/**
	 * This method is for getting the image for the splash screen background.
	 * Depends on whether the image is from url or is static. Right now it is
	 * static.
	 * 
	 * @return
	 */
	private Drawable getSplashImage() {
		return getResources().getDrawable(R.drawable.default_mobicart);
	}

	/**
	 * Method to start all tasks for getting the data.
	 */
	private void prepreForGettingData() {
		new GetAppIdentifierTask(SplashAct.this).execute("");
	}

	@Override
	protected void onResume() {
		prepreForGettingData();
		super.onResume();
	}
}