package com.mobicart.renamed_package;

import org.json.JSONException;

import android.app.ActivityGroup;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;

import com.mobicart.android.communication.CustomException;
import com.mobicart.android.core.MobicartUrlConstants;
import com.mobicart.android.core.StaticPage;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * This Activity Class contains the Information regarding App.
 * 
 * @author mobicart
 * 
 */
public class AboutUsTabAct extends ActivityGroup implements OnClickListener {

	private MyCommonView TitleTV, desc, backBtn, cartBtn,cartEditBtn;
	private StaticPage spage = null;
	private ImageView TitleIV;
	private String title, details;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.about_us_tab_layout);
		prepareViewControls();
		spage = new StaticPage();
		try {
			MobicartCommonData.sPagesVO = spage.getStaticPagesByApp(
					AboutUsTabAct.this, MobicartCommonData.appIdentifierObj
							.getAppId());
		} catch (CustomException e) {
			AlertDialog alertDialog = new AlertDialog.Builder(this).create();
			alertDialog.setTitle(MobicartCommonData.keyValues.getString(
					"key.iphone.nointernet.title", "Alert"));
			alertDialog.setMessage(MobicartCommonData.keyValues.getString(
					"key.iphone.nointernet.text", "Network Error"));
			alertDialog.setButton(MobicartCommonData.keyValues.getString(
					"key.iphone.nointernet.cancelbutton", "Ok"),
					new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
							AboutUsTabAct.this.finish();
						}
					});
			alertDialog.show();
		} catch (NullPointerException e) {
			showServerError();
		} catch (JSONException e) {
			showServerError();
		}
		if (MobicartCommonData.sPagesVO != null) {
			for (int i = 0; i < MobicartCommonData.sPagesVO.size(); i++) {
				title = MobicartCommonData.sPagesVO.get(0).getsTitle();
				details = MobicartCommonData.sPagesVO.get(0).getsDescription();
				TitleTV.setText(title);
				desc.setText(details);
			}
		}
		cartBtn.setOnClickListener(this);
	}

	/**
	 * This Method is used to show Server Errors.
	 */
	private void showServerError() {
		final AlertDialog alertDialog = new AlertDialog.Builder(
				AboutUsTabAct.this).create();
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
	
	/**
	 * This method is called in onCreate() to link the views declared in xml to
	 * the view variables in activity.
	 */
	private void prepareViewControls() {
		TitleIV = (ImageView) findViewById(R.id.common_nav_bar_heading_IV);
		TitleTV = (MyCommonView) findViewById(R.id.common_nav_bar_heading_TV);
		desc = (MyCommonView) findViewById(R.id.terms_text_TV);
		cartEditBtn = TabHostAct.prepareCartButton(this);
		cartEditBtn.setVisibility(View.GONE);

		backBtn = TabHostAct.prepareSoftBackButton(this);
		TitleIV.setImageResource(R.drawable.about_us);
		desc.setTextColor(Color.parseColor("#"
				+ MobicartCommonData.colorSchemeObj.getLabelColor()));
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		cartBtn.setVisibility(View.VISIBLE);
		if (MobicartUrlConstants.resolution == 3) {
			cartBtn.setPadding(0, 4, 12, 0);
		} else {
			cartBtn.setPadding(0, 8, 23, 0);
		}
		cartBtn.setText("" + CartItemCount.getCartCount(this));
	}

	@Override
	protected void onResume() {
		backBtn.setVisibility(View.GONE);
		super.onResume();
	}

	@Override
	protected void onPause() {
		SharedPreferences prefs = getSharedPreferences("X", MODE_PRIVATE);
		Editor editor = prefs.edit();
		editor.putString("lastActivity", getClass().getName());
		editor.commit();
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}

	@Override
	public void onClick(View v) {
		AboutUsGroupAct parentActivity = (AboutUsGroupAct) getParent();
		Intent cartAct = new Intent(this, CartAct.class);
		String backBtn = TitleTV.getText().toString();
		cartAct.putExtra("IsFrom", backBtn);
		cartAct.putExtra("ParentAct", "0");
		parentActivity.startChildActivity("CartAct", cartAct);
	}
}
