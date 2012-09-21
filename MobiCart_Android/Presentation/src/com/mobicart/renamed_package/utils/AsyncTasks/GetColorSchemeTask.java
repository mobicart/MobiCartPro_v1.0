package com.mobicart.renamed_package.utils.AsyncTasks;

import java.text.SimpleDateFormat;
import java.util.Date;
import org.json.JSONException;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.AsyncTask;
import android.widget.EditText;
import android.widget.RelativeLayout;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.AppColorScheme;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * @author mobicart
 * 
 */
public class GetColorSchemeTask extends AsyncTask<String, String, String> {

	private Activity homeTabAct;
	private RelativeLayout homeTopRL;
	private boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * @param act
	 * @param homeTopRL
	 * @param homeSearchET
	 * @param searchButton
	 */
	public GetColorSchemeTask(Activity act, RelativeLayout homeTopRL,
			EditText homeSearchET, MyCommonView searchButton) {
		homeTabAct = act;
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
		this.homeTopRL = homeTopRL;
	}

	@Override
	protected void onPreExecute() {
		super.onPreExecute();
	}

	@Override
	protected String doInBackground(String... params) {
		if (!getColorSchemeData()) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}

	private boolean getColorSchemeData() {
		AppColorScheme appColorScheme = new AppColorScheme();
		try {
			MobicartCommonData.colorSchemeObj = appColorScheme
					.getColorSchemeByAppId(homeTabAct,
							MobicartCommonData.appIdentifierObj.getAppId());
			return true;
		} catch (JSONException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			return false;
		} catch (NullPointerException e) {
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
			if (isNetworkNotAvailable)
				showNetworkError();
			else
				showServerError();
		} else {
			try {
				if ((MobicartCommonData.colorSchemeObj.getSearchColor()
						.equalsIgnoreCase(null))
						|| (MobicartCommonData.colorSchemeObj.getSearchColor()
								.equalsIgnoreCase(""))) {
				} else {
					homeTopRL.setBackgroundColor(Color.parseColor("#"
							+ MobicartCommonData.colorSchemeObj
									.getSearchColor()));
				}
			} catch (Exception e) {
				showServerError();
			}
		}
		super.onPostExecute(result);
	}

	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(homeTabAct
				.getParent()).create();
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
						homeTabAct.getParent().startActivity(intent);
						homeTabAct.getParent().finish();
					}
				});
		alertDialog.show();
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(homeTabAct
				.getParent()).create();
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
						homeTabAct.startActivity(intent);
						homeTabAct.finish();
					}
				});
		alertDialog.show();
	}
}
