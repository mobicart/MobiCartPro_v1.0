package com.mobicart.renamed_package.utils.AsyncTasks;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONException;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.view.View;
import android.widget.ListView;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.Product;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.ProductVO;
import com.mobicart.renamed_package.CartAct;
import com.mobicart.renamed_package.database.DataBaseAccess;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.adapters.CartListAdapter;

/**
 * @author mobicart
 * 
 */
public class GetCartItemTask extends AsyncTask<String, String, String> {

	private Activity currentactivity;
	private ListView CartListView;
	private Activity activity;
	private int getProductId;
	private int cartSize;
	private Product product = new Product();
	private ProductVO cartProduct1 = new ProductVO();
	private boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * @param activity
	 * @param parent
	 * @param cartLV
	 */
	public GetCartItemTask(Activity activity, Activity parent, ListView cartLV) {
		this.CartListView = cartLV;
		this.currentactivity = activity;
		this.activity = parent;
		this.cartSize = CartItemCount.getCartCount(activity);
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
	}

	@Override
	protected void onPreExecute() {
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
		
		for (int iIndex = 0; iIndex < cartSize; iIndex++) {
			getProductId = MobicartCommonData.objCartList.get(iIndex)
					.getProductId();
			try {
				cartProduct1 = product.getProductDetailsByCountryStateStore(
						currentactivity, getProductId,
						MobicartCommonData.territoryId,
						MobicartCommonData.stateId);
				if ((!cartProduct1.getsStatus().equals("active"))
						|| (cartProduct1.getiAggregateQuantity() == 0)) {
					if(cartProduct1.getProductOptions()==null&&cartProduct1.getProductOptions().size()<=0){
					DataBaseAccess database = new DataBaseAccess(activity);
					database.deleteCartItem(MobicartCommonData.objCartList.get(
							iIndex).getId());
					continue;
					}
				}
			} catch (NullPointerException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				return false;
			} catch (JSONException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				DataBaseAccess database = new DataBaseAccess(activity);
				database.deleteCartItem(MobicartCommonData.objCartList.get(
						iIndex).getId());
				continue;
			} catch (CustomException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				isNetworkNotAvailable = true;
				return false;
			}
			MobicartCommonData.cartProductsList.add(cartProduct1);
			
		}
		return true;
	}

	@Override
	protected void onPostExecute(String result) {
		if (result.equalsIgnoreCase("FALSE")) {
			if (isNetworkNotAvailable) {
				showNetworkError();
			} else
				showServerError();
		} else {
			cartSize = CartItemCount.getCartCount(activity);
			if (cartSize == 0) {
				CartAct.footerLayout.setVisibility(View.GONE);
			}
			CartListView.setAdapter(new CartListAdapter(currentactivity,
					activity, MobicartCommonData.objCartList));
			super.onPostExecute(result);
		}
	}

	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(this.activity)
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
						activity.startActivity(intent);
						activity.finish();
					}
				});
		alertDialog.show();
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(this.activity)
				.create();
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
