package com.mobicart.renamed_package.utils.AsyncTasks;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONException;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.view.animation.Animation;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.TranslateAnimation;
import android.widget.Gallery;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.Product;
import com.mobicart.android.core.Tax;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.TaxVO;
import com.mobicart.renamed_package.GetCountryNStateAct;
import com.mobicart.renamed_package.MyAcountDetails;
import com.mobicart.renamed_package.SignUpAct;
import com.mobicart.renamed_package.utils.adapters.FeaturedGalleryAdapter;

/**
 * @author mobicart
 * 
 */

public class GetImagesTask extends AsyncTask<String, String, String> {

	private Activity currentContext;
	private FeaturedGalleryAdapter featuredGalleryAdapter;
	private Gallery gallery;
	public static boolean isFeaturedListUpdated = false;
	private boolean isNetworkNotAvailable = false;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * 
	 * @param activity
	 * @param homeGallery
	 */
	public GetImagesTask(Activity activity, Gallery homeGallery) {
		this.gallery = homeGallery;
		this.currentContext = activity;
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
	}

	@Override
	protected void onPreExecute() {
		super.onPreExecute();
	}

	@Override
	protected String doInBackground(String... strings) {
		if (!getGalleryImageData()) {
			return "FALSE";
		} else {
			return "TRUE";
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
			gallery.setAdapter(featuredGalleryAdapter);
			gallery.setSelection(1);
			gallery.setAnimation(inFromLeftAnimation());
		}
		super.onPostExecute(result);
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

	private void showserverError() {
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

	private boolean getGalleryImageData() {
		boolean flag = true;
		if (MobicartCommonData.featuredPrducts.size() > 0) {
			if (SignUpAct.isLogged) {
				SignUpAct.isLogged = false;
				isFeaturedListUpdated = true;
				flag = fillFeaturedList();
			}
			if (MyAcountDetails.isUpdated) {
				MyAcountDetails.isUpdated = false;
				isFeaturedListUpdated = true;
				flag = fillFeaturedList();
			}
			if (MobicartCommonData.isFromStart == "") {
				isFeaturedListUpdated = true;
				flag = fillFeaturedList();
			}
			featuredGalleryAdapter = new FeaturedGalleryAdapter(currentContext);
			return flag;
		} else {
			flag = fillFeaturedList();
			return flag;
		}
	}

	private boolean fillFeaturedList() {
		GetCountryNStateAct getCountryNState = new GetCountryNStateAct(
				currentContext);
		Product featured = new Product();
		Tax objTax = new Tax();
		MobicartCommonData.tax = new TaxVO();
		if (MobicartCommonData.objAccountVO.get_id() > 0) {
			MobicartCommonData.territoryId = getCountryNState
					.checkId(MobicartCommonData.objAccountVO
							.getsDeliveryCountry());
			MobicartCommonData.stateId = getCountryNState
					.checkstateId(MobicartCommonData.objAccountVO
							.getsDeliveryState());
			try {
				MobicartCommonData.featuredPrducts = featured
						.getFeaturedProductsByCountryStateStore(currentContext,
								MobicartCommonData.appIdentifierObj.getAppId(),
								MobicartCommonData.territoryId,
								MobicartCommonData.stateId);
				MobicartCommonData.tax = objTax.findTaxByCountryStateStore(
						currentContext, MobicartCommonData.appIdentifierObj
								.getStoreId(), MobicartCommonData.territoryId,
						MobicartCommonData.stateId);
			} catch (JSONException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				return false;
			} catch (NullPointerException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				return false;
			} catch (CustomException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				isNetworkNotAvailable = true;
				return false;
			}
		} else {
			try {
				MobicartCommonData.featuredPrducts = featured
						.getFeaturedProducts(currentContext,
								MobicartCommonData.appIdentifierObj.getAppId());
				MobicartCommonData.tax = objTax.findTaxByCountryStateStore(
						currentContext, MobicartCommonData.appIdentifierObj
								.getStoreId(), MobicartCommonData.territoryId,
						MobicartCommonData.stateId);
			} catch (JSONException e) {
				objMobicartLogger.LogExceptionMsg(reqDateFormat
						.format(new Date()), e.getMessage());
				return false;
			} catch (NullPointerException e) {
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
		featuredGalleryAdapter = new FeaturedGalleryAdapter(currentContext);
		return true;
	}

	private Animation inFromLeftAnimation() {
		Animation inFromLeft = new TranslateAnimation(
				Animation.RELATIVE_TO_PARENT, -1.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f,
				Animation.RELATIVE_TO_PARENT, 0.0f);
		inFromLeft.setDuration(800);
		inFromLeft.setInterpolator(new DecelerateInterpolator());
		return inFromLeft;
	}
}
