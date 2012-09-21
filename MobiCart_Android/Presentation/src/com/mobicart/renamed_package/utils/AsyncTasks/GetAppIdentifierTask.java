package com.mobicart.renamed_package.utils.AsyncTasks;

import java.text.SimpleDateFormat;
import java.util.Currency;
import java.util.Date;
import org.json.JSONException;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.AppColorScheme;
import com.mobicart.android.core.AppIdentifier;
import com.mobicart.android.core.AppVitals;
import com.mobicart.android.core.Store;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.ChkLoginStatusAct;
import com.mobicart.renamed_package.LangPkgAct;
import com.mobicart.renamed_package.constants.MobiCartConstantIds;

/**
 * @author mobicart
 * 
 */
public class GetAppIdentifierTask extends AsyncTask<String, String, String> {

	private Activity activity;
	private boolean isNetworkNotAvailable = false;
	public static String applicationCurrency;
	public static boolean isFirstTime = true;
	private ChkLoginStatusAct chkLoginStatus;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * @param activity
	 * @param backgroundView
	 */
	public GetAppIdentifierTask(Activity activity) {
		this.activity = activity;
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		chkLoginStatus = new ChkLoginStatusAct(this.activity);
	}

	@Override
	protected String doInBackground(String... urls) {
		if (!getAppData()) {
			return "FALSE";
		}
		return "true";
	}

	private boolean getAppData() {
		AppIdentifier appIdentifier = new AppIdentifier();
		AppVitals appVitals = new AppVitals();
		AppColorScheme appColorScheme = new AppColorScheme();
		try {
			if (isFirstTime) {
				MobicartCommonData.appIdentifierObj = appIdentifier
						.getStoreIdAndAppIdByUserName(activity,
								MobiCartConstantIds.userName);
			}
			MobicartCommonData.storeVO = new Store().getStoreSettings(activity,
					MobicartCommonData.appIdentifierObj.getStoreId());
			MobicartCommonData.appVitalsObj = appVitals.getAppVitals(activity,
					MobicartCommonData.appIdentifierObj.getAppId());
			MobicartCommonData.colorSchemeObj = appColorScheme
					.getColorSchemeByAppId(activity,
							MobicartCommonData.appIdentifierObj.getAppId());
			return true;
		} catch (NullPointerException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			return false;
		} catch (JSONException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			return false;
		} catch (CustomException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			isNetworkNotAvailable = true;
			return false;
		}
	}

	@Override
	protected void onPostExecute(String result) {
		if (result.equalsIgnoreCase("FALSE")) {
			if (isNetworkNotAvailable) {
				showNetworkError();
			} else
				showServerError();
		} else {
			try {
				chkLoginStatus.chkUserExistOrNot();
			} catch (NullPointerException e) {
			}
			MobicartCommonData.keyValues = activity.getSharedPreferences(
					"KeyValue", Context.MODE_PRIVATE);
			if(MobicartCommonData.storeVO!=null){
			MobicartCommonData.shippingObj =MobicartCommonData.storeVO.getShippingList();
			MobicartCommonData.taxObj = MobicartCommonData.storeVO.getTaxList();
			// fetching details from zooz fields
			MobiCartConstantIds.PAYPAL_EMAIL_ID =(MobicartCommonData.storeVO.getAndroidUniqueId()==null)?"":MobicartCommonData.storeVO.getAndroidUniqueId();
			MobiCartConstantIds.PAYPAL_APP_ID = (MobicartCommonData.storeVO.getAndroidAppKey()==null)?"":MobicartCommonData.storeVO.getAndroidAppKey();;
			MobiCartConstantIds.PAYPAL_SERVER_MODE = (MobicartCommonData.storeVO.getPayPalLive()==null)?"":MobicartCommonData.storeVO.getPayPalLive();;
			}
			activity.startActivity(new Intent(activity, LangPkgAct.class));
			try {
				applicationCurrency = Currency.getInstance(
						MobicartCommonData.storeVO.getsCurrencyCode())
						.getSymbol();
				MobicartCommonData.currencySymbol = applicationCurrency;
			} catch (NullPointerException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				showServerError();
			}
			activity.finish();
			super.onPostExecute(result);
		}
	}

	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(activity).create();
		alertDialog.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.title", "Alert"));
		alertDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.text", "Network Error"));
		alertDialog.setButton(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.cancelbutton", "Ok"),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent intent = new Intent(Intent.ACTION_MAIN);
						intent.addCategory(Intent.CATEGORY_HOME);
						intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						activity.startActivity(intent);
						activity.finish();
					}
				});
		alertDialog.show();
	}

	private void showServerError() {
		AlertDialog alertDialog = new AlertDialog.Builder(activity).create();
		alertDialog.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.server.notresp.title.error", "Alert"));
		alertDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.server.notresp.text", "Server not Responding"));
		alertDialog.setButton(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.cancelbutton", "OK"),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						Intent intent = new Intent(Intent.ACTION_MAIN);
						intent.addCategory(Intent.CATEGORY_HOME);
						intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						activity.startActivity(intent);
						activity.finish();
					}
				});
		alertDialog.show();
	}

	@Override
	protected void onProgressUpdate(String... values) {
		super.onProgressUpdate(values);
	}
}
