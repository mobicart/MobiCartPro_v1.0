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
import com.mobicart.android.core.Product;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.android.model.CartItemVO;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.renamed_package.utils.adapters.CheckoutListAdapter;

/**
 * @author mobicart
 * 
 */
public class GetCheckoutCartItemTask extends AsyncTask<String, String, String> {

	private Activity currentactivity;
	private ListView checkoutListView;
	private ArrayList<CartItemVO> cartListVO;
	private ProgressDialog progressDialog;
	private DataBaseAccess database;
	private int getProductId;
	private Product product = new Product();
	private ProductVO cartProduct = new ProductVO();
	private boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * @param activity
	 * @param checkoutLV
	 */
	public GetCheckoutCartItemTask(Activity activity, ListView checkoutLV) {
		this.checkoutListView = checkoutLV;
		this.currentactivity = activity;
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
		progressDialog = new ProgressDialog(activity.getParent());
		progressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
		progressDialog.setMessage(MobicartCommonData.keyValues.getString(
				"key.iphone.LoaderText", ""));
		progressDialog.setCancelable(false);
	}

	@Override
	protected void onPreExecute() {
		progressDialog.show();
		super.onPreExecute();
	}

	@Override
	protected String doInBackground(String... params) {
		if (!getCartListItem()) {
			return "FALSE";
		} else {
			return "TRUE";
		}
	}

	private boolean getCartListItem() {
		database = new DataBaseAccess(currentactivity);
		cartListVO = database.GetRows("SELECT * from "
				+ CartItemVO.CART_TABLE_NAME, new CartItemVO());
		for (int iIndex = 0; iIndex < cartListVO.size(); iIndex++) {
			getProductId = cartListVO.get(iIndex).getProductId();
			try {
				cartProduct = product.getProductDetailsByCountryStateStore(
						currentactivity, getProductId,
						MobicartCommonData.territoryId,
						MobicartCommonData.stateId);
				return true;
			} catch (NullPointerException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				return false;
			} catch (JSONException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				return false;
			} catch (CustomException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				isNetworkNotAvailable = true;
				return false;
			}
		}
		return false;
	}

	@Override
	protected void onPostExecute(String result) {
		if (result.equalsIgnoreCase("FALSE")) {
			if (isNetworkNotAvailable)
				showNetworkError();
			else
				showServerError();
		} else {
			checkoutListView.setAdapter(new CheckoutListAdapter(
					currentactivity, cartListVO, cartProduct));
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
