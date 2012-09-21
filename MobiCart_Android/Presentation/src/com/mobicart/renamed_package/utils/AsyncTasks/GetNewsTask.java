package com.mobicart.renamed_package.utils.AsyncTasks;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONException;


import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.view.View;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioGroup;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.News;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.R;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.adapters.NewsListAdapter;

/**
 * This is News Task retrive news from web service
 * 
 * @author mobicart
 * 
 */

public class GetNewsTask extends AsyncTask<String, String, String> {

	private Activity currentactivity;
	private ListView newsList;
	private ProgressDialog progressDialog;
	private RadioGroup radioGroup;
	private ImageView headerIV;
	private MyCommonView headerTitle;
	private boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * @param activity
	 * @param newsListview
	 * @param radioGroup
	 * @param headerIV
	 * @param headerTitle
	 */
	public GetNewsTask(Activity activity, ListView newsListview,
			RadioGroup radioGroup, ImageView headerIV, MyCommonView headerTitle) {

		this.newsList = newsListview;
		this.currentactivity = activity;
		this.radioGroup = radioGroup;
		this.headerIV = headerIV;
		this.headerTitle = headerTitle;
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
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
		if (!getNewsData()) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}

	private boolean getNewsData() {
		News newsObj = new News();
		try {
			MobicartCommonData.newsList = newsObj.getNewsItems(currentactivity,
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
			if (isNetworkNotAvailable)
				showNetworkError();
			else
				showServerError();
		} else {
			if (MobicartCommonData.newsList.size() == 0) {
			} else {
				if (MobicartCommonData.newsList.size() == 1
						&& MobicartCommonData.newsList.get(0).getsTitle() == ""
						|| MobicartCommonData.newsList.get(0).getsTitle()
								.equalsIgnoreCase(null)) {
					if (MobicartCommonData.newsList.get(0).isbTwitterStatus() == false) {
						newsList
						.setAdapter(new NewsListAdapter(currentactivity));
					} else {
						headerIV.setImageResource(R.drawable.twitter_icon);
						headerTitle.setText("Tweets");
						GetTwitterTask tnewsTask = new GetTwitterTask(
								currentactivity, newsList);
						tnewsTask.execute("");
					}
				} else {
					if (MobicartCommonData.newsList.size() >= 1) {
						newsList
								.setAdapter(new NewsListAdapter(currentactivity));
						for (int i = 0; i < MobicartCommonData.newsList.size(); i++) {

							if (MobicartCommonData.newsList.get(i)
									.isbTwitterStatus() == true) {
								radioGroup.setVisibility(View.VISIBLE);
							}
						}
					}
				}
			}
		}
		try {
			progressDialog.dismiss();
			progressDialog = null;
		} catch (Exception e) {

		}
		super.onPostExecute(result);
	}

	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(this.currentactivity)
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
						currentactivity.startActivity(intent);
						currentactivity.finish();
					}
				});
		alertDialog.show();
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(
				this.currentactivity).create();
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
}