package com.mobicart.renamed_package.utils.AsyncTasks;

import java.text.SimpleDateFormat;
import java.util.Date;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.widget.ListView;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.TwitterFeed;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.adapters.TwitterListAdapter;

/**
 * @author mobicart
 * 
 */
public class GetTwitterTask extends AsyncTask<String, Boolean, Boolean> {

	private ProgressDialog progressDialog1;
	private Activity currentactivity;
	private ListView twitterList;
	private TwitterFeed tFeed;
	private boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * @param activity
	 * @param twitterLV
	 */
	public GetTwitterTask(Activity activity, ListView twitterLV) {
		this.twitterList = twitterLV;
		this.currentactivity = activity;
		progressDialog1 = new ProgressDialog(activity.getParent());
		progressDialog1.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog1.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.LoaderText", ""));
		progressDialog1.setCancelable(false);
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
	}

	@Override
	protected void onPreExecute() {
		progressDialog1.show();
		super.onPreExecute();
	}

	@Override
	protected Boolean doInBackground(String... urls) {
		if (!getTwitterTask()) {
			return false;
		}
		return true;
	}

	private Boolean getTwitterTask() {
		tFeed = new TwitterFeed();
		try {
			MobicartCommonData.tweetFeedVO = tFeed.getTwitterFeed(
					currentactivity, MobicartCommonData.appIdentifierObj
							.getStoreId());
			return true;
		} catch (CustomException e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
			isNetworkNotAvailable = true;
			return false;
		}
	}

	@Override
	protected void onPostExecute(Boolean result) {
		if (result) {
			twitterList.setAdapter(new TwitterListAdapter(currentactivity));
			twitterList.setOnItemClickListener(null);
		} else {
			twitterList.setAdapter(null);
			if (isNetworkNotAvailable)
				showNetworkError();
			else
				showServerError();
		}
		try {
			progressDialog1.dismiss();
			progressDialog1 = null;
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
