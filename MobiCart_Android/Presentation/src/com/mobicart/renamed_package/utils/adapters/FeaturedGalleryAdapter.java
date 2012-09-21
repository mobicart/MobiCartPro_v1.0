package com.mobicart.renamed_package.utils.adapters;

import java.text.SimpleDateFormat;
import java.util.Date;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.mobicart.android.communication.MobicartLogger;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.GetCountryNStateAct;
import com.mobicart.renamed_package.R;
import com.mobicart.renamed_package.utils.ImageLoader;
import com.mobicart.renamed_package.utils.MyCommonView;
import com.mobicart.renamed_package.utils.ProductTax;
import com.mobicart.renamed_package.utils.AsyncTasks.GetImagesTask;

/**
 * @author mobicart
 * 
 */

public class FeaturedGalleryAdapter extends BaseAdapter {

	private Activity mContext;
	private LayoutInflater layoutInflater;
	private GradientDrawable gredientPriceDrawable;
	private GetCountryNStateAct getCountryNState;
	public ImageLoader imageLoader;
	private ImageView imgView;
	private MobicartLogger objMobicartLogger;
	private SimpleDateFormat reqDateFormat;

	/**
	 * @param activity
	 */
	public FeaturedGalleryAdapter(Activity activity) {

		mContext = activity;
		layoutInflater = mContext.getLayoutInflater();
		objMobicartLogger = new MobicartLogger("MobicartServiceLogger");
		reqDateFormat = new SimpleDateFormat("MMM. dd,yyyy kk:mm:ss ");
		imageLoader = new ImageLoader(activity.getApplicationContext());
		if ((MobicartCommonData.finalPrice.size() <= 0)
				|| (MobicartCommonData.taxArray.size() <= 0)) {
			getTaxByCountryStateStore();
		}
		gredientPriceDrawable = (GradientDrawable) mContext.getResources()
				.getDrawable(R.drawable.rounded_button);
		if (GetImagesTask.isFeaturedListUpdated) {
			GetImagesTask.isFeaturedListUpdated = false;
			MobicartCommonData.finalPrice.clear();
			MobicartCommonData.taxArray.clear();
			getTaxByCountryStateStore();
		}
	}

	private void getTaxByCountryStateStore() {
		getCountryNState = new GetCountryNStateAct(mContext);
		Double price = 0.0;
		String tax = "";
		try {
			if (MobicartCommonData.featuredPrducts != null) {
				for (int i = 0; i < MobicartCommonData.featuredPrducts.size(); i++) {
					if (MobicartCommonData.objAccountVO.get_id() > 0) {
						MobicartCommonData.territoryId = getCountryNState
								.checkId(MobicartCommonData.objAccountVO
										.getsDeliveryCountry());
						MobicartCommonData.stateId = getCountryNState
								.checkstateId(MobicartCommonData.objAccountVO
										.getsDeliveryState());
						price = ProductTax
								.calculateFinalPriceByUserLocation(MobicartCommonData.featuredPrducts
										.get(i));
						tax = ProductTax
								.calculateTaxByUserLocation(MobicartCommonData.featuredPrducts
										.get(i));
					} else {
						price = ProductTax
								.calculateFinalPriceByUserLocation(MobicartCommonData.featuredPrducts
										.get(i));
						tax = ProductTax
								.calculateTaxByUserLocation(MobicartCommonData.featuredPrducts
										.get(i));
					}
					MobicartCommonData.finalPrice.add(price);
					MobicartCommonData.taxArray.add(tax);
				}
			}
		} catch (Exception e) {
			objMobicartLogger.LogExceptionMsg(reqDateFormat.format(new Date()),
					e.getMessage());
		}
	}

	public int getCount() {
		return MobicartCommonData.featuredPrducts.size();
	}

	public Object getItem(int position) {
		return null;
	}

	public long getItemId(int position) {
		return 0;
	}

	public View getView(int position, View convertView, ViewGroup parent) {
		RelativeLayout galleryPriceRL = null;
		RelativeLayout imgRL = null;
		ViewHolder holder = new ViewHolder();
		if (MobicartCommonData.featuredPrducts.size() == 1) {
			position = 0;
		}
		if (convertView == null) {
			convertView = layoutInflater.inflate(R.layout.home_gallery_layout,
					null);
			imgRL = (RelativeLayout) convertView
					.findViewById(R.id.home_gallery_iv);
			galleryPriceRL = (RelativeLayout) convertView
					.findViewById(R.id.home_gallery_price_rl);
			holder.priceTV = (MyCommonView) convertView
					.findViewById(R.id.home_gallery_price_tv);
			holder.taxTV = (MyCommonView) convertView
					.findViewById(R.id.home_gallery_price_tax_tv);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		String tax = "";
		holder.priceTV.setText(MobicartCommonData.currencySymbol
				+ String.format("%.2f", MobicartCommonData.finalPrice
						.get(position)));
		tax = MobicartCommonData.taxArray.get(position);
		try {
			if (tax == null || tax.equalsIgnoreCase("") || tax.length() < 1) {
				holder.taxTV.setVisibility(View.GONE);
				galleryPriceRL.setBackgroundResource(R.drawable.price_list_02_);
				if (MobicartCommonData.colorSchemeObj.getSearchColor()
						.equalsIgnoreCase("null")
						|| MobicartCommonData.colorSchemeObj.getSearchColor()
								.equalsIgnoreCase("")) {
					gredientPriceDrawable.setColor(Color.parseColor("#313131"));
					galleryPriceRL.setBackgroundDrawable(gredientPriceDrawable);
				} else {
					gredientPriceDrawable.setColor(Color.parseColor("#"
							+ MobicartCommonData.colorSchemeObj
									.getSearchColor()));
					galleryPriceRL.setBackgroundDrawable(gredientPriceDrawable);
				}
			} else {
				galleryPriceRL.setBackgroundResource(R.drawable.price_list_01_);
				if (MobicartCommonData.colorSchemeObj.getSearchColor()
						.equalsIgnoreCase("null")
						|| MobicartCommonData.colorSchemeObj.getSearchColor()
								.equalsIgnoreCase("")) {
					gredientPriceDrawable.setColor(Color.parseColor("#313131"));
					galleryPriceRL.setBackgroundDrawable(gredientPriceDrawable);
				} else {
					gredientPriceDrawable.setColor(Color.parseColor("#"
							+ MobicartCommonData.colorSchemeObj
									.getSearchColor()));
					galleryPriceRL.setBackgroundDrawable(gredientPriceDrawable);
				}
				holder.taxTV.setText(tax.toLowerCase());
			}
		} catch (Exception e) {
			showServerError();
		}
		String imageUrl = "";
		if (MobicartCommonData.featuredPrducts.get(position).getProductImages() != null) {
			if (MobicartCommonData.featuredPrducts.get(position)
					.getProductImages().size() == 0) {
			}
			if (MobicartCommonData.featuredPrducts.get(position)
					.getProductImages().size() > 0) {
				imageUrl = MobicartCommonData.featuredPrducts.get(position)
						.getProductImages().get(0).getProductImageSmall();
				imgView = new ImageView(mContext);
				imgView.setLayoutParams(new LayoutParams(
						LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
				imgView.setTag(MobicartUrlConstants.baseImageUrl.substring(0,
						MobicartUrlConstants.baseImageUrl.length() - 1)
						+ imageUrl);
				imageLoader.DisplayImage(MobicartUrlConstants.baseImageUrl
						.substring(0, MobicartUrlConstants.baseImageUrl
								.length() - 1)
						+ imageUrl, mContext, imgView);
				imgRL.addView(imgView);
			}
		}
		return convertView;
	}

	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(mContext)
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

	private class ViewHolder {
		MyCommonView priceTV;
		MyCommonView taxTV;
	}
}
