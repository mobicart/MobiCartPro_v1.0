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
import android.widget.ListView;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.ProductOrder;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.adapters.OrderListAadpter;

/**
 * @author mobicart
 * 
 */
public class GetProductOrder extends AsyncTask<String, String, String> {

	private Activity currentactivity;
	private ListView orderListLV;
	private ProgressDialog progressDialog;
	private String email;
	private boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * @param activity
	 * @param orderListView
	 * @param email2
	 */
	public GetProductOrder(Activity activity, ListView orderListView,
			String email2) {
		this.orderListLV = orderListView;
		this.currentactivity = activity;
		this.email = email2;
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
		if (!getProductOrder()) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}

	private boolean getProductOrder() {
		ProductOrder productOrder = new ProductOrder();
		try {
			MobicartCommonData.productOrderVO = productOrder
					.getOrderHistoryGET(currentactivity,
							MobicartCommonData.appIdentifierObj.getAppId(),
							MobicartCommonData.appIdentifierObj.getStoreId(),
							email);
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
				showserverError();
		} else {
			orderListLV.setAdapter(new OrderListAadpter(currentactivity));
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

	private void showserverError() {
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
