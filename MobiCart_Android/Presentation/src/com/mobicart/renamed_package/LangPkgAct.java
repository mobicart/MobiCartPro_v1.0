package com.mobicart.renamed_package;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import com.google.android.gcm.GCMRegistrar;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.constants.MobiCartConstantIds;
import com.mobicart.renamed_package.utils.AsyncTasks.GetLangPackTask;

/**
 * This Activity is used to call Async Task to get data from service to
 * implement Language pack in App.
 * 
 * @author mobicart
 * 
 */
public class LangPkgAct extends Activity {

	private View backgroundView;
	private String regID;

	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);
		MobicartCommonData.isFromStart = "";
		backgroundView = new View(this);
		backgroundView
				.setBackgroundResource(com.mobicart.renamed_package.R.drawable.default_mobicart);
		setContentView(backgroundView);
		register();
		/*if (GetAppIdentifierTask.isFirstTime) {
			GetAppIdentifierTask.isFirstTime = false;
			register();
		}*/
		MobicartCommonData.keyValues = this.getSharedPreferences("KeyValue",
				Context.MODE_PRIVATE);
		if ((MobicartCommonData.keyValues.getString("filled", "False"))
				.equalsIgnoreCase("True")) {
			GetLangPackTask getLangPackTask = new GetLangPackTask(this,
					MobicartCommonData.keyValues.getString("TimeStamp", "NA"));
			getLangPackTask.execute("");
		} else {
			GetLangPackTask getLangPackTask = new GetLangPackTask(this);
			getLangPackTask.execute("");
		}
	}

	/**
	 * This Method is used for registering a device To GCM sever to get
	 * Notifications from Server.
	 */
	private void register() {
		GCMRegistrar.checkDevice(this.getApplicationContext());
        GCMRegistrar.checkManifest(this.getApplicationContext());
        regID = GCMRegistrar.getRegistrationId(this.getApplicationContext());
         if (regID.equals("")) {
          GCMRegistrar.register(this.getApplicationContext(), MobiCartConstantIds.GCM_SENDER_ID);
          regID= GCMRegistrar.getRegistrationId(this.getApplicationContext());
        } 
    }
	@Override
	protected void onPause() {
		finish();
		super.onPause();
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
	}
}
