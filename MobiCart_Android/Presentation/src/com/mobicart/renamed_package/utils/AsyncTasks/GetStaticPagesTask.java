package com.mobicart.renamed_package.utils.AsyncTasks;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONException;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.widget.ListView;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.StaticPage;
import com.mobicart.android.model.FeatureVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.adapters.MoreListAdapter;

/**
 * @author mobicart
 * 
 */

public class GetStaticPagesTask extends AsyncTask<String, String, String> {

	private ProgressDialog progressDialog;
	private Activity currentContext;
	public boolean test = true;
	private ArrayList<FeatureVO> list;
	private ListView moreLV;
	private Boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * @param activity
	 * @param moreListView
	 * @param branding
	 * @param animText
	 */
	public GetStaticPagesTask(Activity activity, ListView moreListView) {
		this.moreLV = moreListView;
		currentContext = activity;
		progressDialog = new ProgressDialog(activity.getParent());
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.LoaderText", ""));
		progressDialog.setCancelable(false);
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
	}

	@Override
	protected void onPreExecute() {
		progressDialog.show();
		super.onPreExecute();
	}

	@Override
	protected String doInBackground(String... params) {
		if (getStaticPages())
			return "TRUE";
		else
			return "FALSE";
	}

	private Boolean getStaticPages() {
		StaticPage spages = new StaticPage();
		try {
			MobicartCommonData.sPagesVO = spages.getStaticPagesByApp(
					currentContext, MobicartCommonData.appIdentifierObj
							.getAppId());
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
			isNetworkNotAvailable = true;
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			return false;
		}
	}

	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(this.currentContext)
				.create();
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
						currentContext.startActivity(intent);
						currentContext.finish();
					}
				});
		alertDialog.show();
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(
				this.currentContext).create();
		alertDialog.setTitle(MobicartCommonData.keyValues.getString(
				"key.iphone.server.notresp.title.error", "Alert"));
		alertDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.server.notresp.text", "Server not Responding"));
		alertDialog.setButton(MobicartCommonData.keyValues.getString(
				"key.iphone.nointernet.cancelbutton", "OK"),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						alertDialog.cancel();
					}
				});
		alertDialog.show();
	}

	private ArrayList<FeatureVO> preparePageas() {
		list = new ArrayList<FeatureVO>();
		int counter = 0;
		for (int i = 0; i < MobicartCommonData.appVitalsObj.getFeaturesList()
				.size(); i++) {
			if (MobicartCommonData.appVitalsObj.getFeaturesList().get(i)
					.getEnabled()) {
				counter++;
			}
			if (counter > 4) {
				list.add(MobicartCommonData.appVitalsObj.getFeaturesList().get(
						i));
			}
		}
		return list;
	}

	@Override
	protected void onPostExecute(String result) {
		super.onPostExecute(result);
		if (result.equalsIgnoreCase("FALSE")) {
			if (isNetworkNotAvailable)
				showNetworkError();
			else
				showServerError();
		} else {
			new ArrayList<FeatureVO>();
			preparePageas();
		}
		moreLV.setAdapter(new MoreListAdapter(currentContext, list));
		try {
			progressDialog.dismiss();
			progressDialog = null;
		} catch (Exception e) {
		}
	}
}
