package com.mobicart.renamed_package;

import java.util.List;

import org.json.JSONException;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;
import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.core.UserAddress;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.android.model.UserAddressVO;
import com.mobicart.renamed_package.constants.MobiCartConstantIds;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * This Activity is used to show user address on Google Map.
 * 
 * @author mobicart
 * 
 */
public class ContactUsAct extends MapActivity implements OnClickListener {

	private MyCommonView TitleTV, backButton, contact_addressInfo_TV, cartBtn,cartEditBtn;
	private ImageView TitleImageView;
	private MapView myMapView;
	private MapController myMC = null;
	private Geocoder geoCoder;
	private double latitude, longitude;
	private List<Overlay> mapOverlays;
	private Drawable drawable;
	private MarkerItemizedOverlay markerOverlay;
	private String finalCompleteAddress = "";
	private String sAddress = null;
	private String sCity = null;
	private String sState = null;
	private String sCountry = null;
	private String title;
	private String description;
	private UserAddressVO uAddVO;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.contact_us_layout);
		Bundle extra = getIntent().getExtras();
		title = extra.getString("Title");
		description = extra.getString("Descripition");
		UserAddress uaddress = new UserAddress();
		try {
			uAddVO = uaddress.getUserAddress(ContactUsAct.this,
					MobiCartConstantIds.userName);
			if (uAddVO.getsAddress().equals("") || uAddVO.getsAddress() == null)
				sAddress = "";
			else
				sAddress = uAddVO.getsAddress();
			sCity = uAddVO.getsCity();
			sState = uAddVO.getsState();
			sCountry = uAddVO.getsCountry();
		} catch (NullPointerException e1) {
			showServerError();
		} catch (JSONException e1) {
			showServerError();
		} catch (CustomException e) {
			showNetworkError();
		}
		finalCompleteAddress = finalCompleteAddress
				.concat(!sAddress.equals("") ? sAddress != null ? sAddress
						+ "," : "" : "");
		finalCompleteAddress = finalCompleteAddress
				.concat(!sCity.equals("") ? sCity != null ? sCity + "," : ""
						: "");
		finalCompleteAddress = finalCompleteAddress
				.concat(!sState.equals("") ? sState != null ? sState + "," : ""
						: "");
		finalCompleteAddress = finalCompleteAddress
				.concat(!sCountry.equals("") ? sCountry != null ? sCountry : ""
						: "");
		int TitleImage = extra.getInt("Image");
		myMapView = (MapView) findViewById(R.id.myGMap);

		geoCoder = new Geocoder(this);
		try {

			List<Address> foundAdresses = geoCoder.getFromLocationName(
					finalCompleteAddress, 5);
			for (int i = 0; i < foundAdresses.size(); i++) {
				Address x = foundAdresses.get(i);
				latitude = x.getLatitude();
				longitude = x.getLongitude();
			}
			navigateToLocation((latitude * 1000000), (longitude * 1000000),
					myMapView, finalCompleteAddress);
		} catch (Exception e) {
		}
		myMapView.setBuiltInZoomControls(true);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setVisibility(View.VISIBLE);
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		cartBtn.setOnClickListener(this);
		if (MobicartUrlConstants.resolution == 3) {
			cartBtn.setPadding(0, 4, 12, 0);
		} else {
			cartBtn.setPadding(0, 8, 23, 0);
		}
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		TitleImageView = (ImageView) findViewById(R.id.common_nav_bar_heading_IV);
		TitleImageView.setImageDrawable(getResources().getDrawable(TitleImage));
		TitleTV = (MyCommonView) findViewById(R.id.common_nav_bar_heading_TV);
		contact_addressInfo_TV = (MyCommonView) findViewById(R.id.contact_addressInfo2_TV);

		backButton = TabHostAct.prepareSoftBackButton(this);
		backButton.setVisibility(View.VISIBLE);
		backButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.more", ""));
		backButton.setOnClickListener(this);
		TitleTV.setText(title);
		contact_addressInfo_TV.setText(description);
		contact_addressInfo_TV.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
	}

	/**
	 * This Method is used to show Network related errors.
	 */
	private void showNetworkError() {
		AlertDialog alertDialog = new AlertDialog.Builder(ContactUsAct.this)
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
						ContactUsAct.this.startActivity(intent);
						ContactUsAct.this.finish();
					}
				});
		alertDialog.show();
	}

	/**
	 * This Method is used to show Server Errors.
	 */
	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(
				ContactUsAct.this.getParent()).create();
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

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}

	/**
	 * This Method is used to navigate on address or location of user.
	 * 
	 * @param d
	 * @param e
	 * @param myMapView2
	 * @param cAddress
	 */
	private void navigateToLocation(double d, double e, MapView myMapView2,
			String cAddress) {
		drawable = this.getResources().getDrawable(R.drawable.bubble);
		markerOverlay = new MarkerItemizedOverlay(drawable, this, cAddress);
		GeoPoint geoPoint = new GeoPoint((int) d, (int) e); // new GeoPoint
		mapOverlays = myMapView2.getOverlays();// done
		OverlayItem overlayitem = new OverlayItem(geoPoint, "Hi", "Hello");
		mapOverlays.add(markerOverlay);
		markerOverlay.addOverlay(overlayitem);
		myMC = myMapView.getController();
		myMC.setCenter(geoPoint);
		myMC.setZoom(15);
		myMC.animateTo(geoPoint);
		myMapView2.setBuiltInZoomControls(true);
		myMapView2.displayZoomControls(true);
		myMapView2.setSatellite(false);
	}

	@Override
	protected void onResume() {
		backButton.setVisibility(View.VISIBLE);
		backButton.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.tabbar.more", ""));
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		backButton.setOnClickListener(this);
		super.onResume();
	}

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		backButton.setVisibility(View.GONE);
		super.onDestroy();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_I) {
			myMapView.getController().setZoom(myMapView.getZoomLevel() + 1);
			return true;
		} else if (keyCode == KeyEvent.KEYCODE_O) {
			myMapView.getController().setZoom(myMapView.getZoomLevel() - 1);
			return true;
		} else if (keyCode == KeyEvent.KEYCODE_S) {
			myMapView.setSatellite(true);
			return true;
		} else if (keyCode == KeyEvent.KEYCODE_M) {
			myMapView.setSatellite(false);
			return true;
		}
		return false;
	}

	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.universal_back_btn: {
			finish();
			break;
		}
		case R.id.navigation_bar_cart_btn:
			MoreTabGroupAct parentActivity = (MoreTabGroupAct) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = MobicartCommonData.keyValues.getString(
					"key.iphone.more.contactus", "Contact Us");
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "5");
			parentActivity.startChildActivity("CartAct", cartAct);
			break;
		}
	}
}