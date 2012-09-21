package com.mobicart.renamed_package.utils.coverflow;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.CartAct;
import com.mobicart.renamed_package.ParentActivityGroup;
import com.mobicart.renamed_package.R;
import com.mobicart.renamed_package.TabHostAct;
import com.mobicart.renamed_package.utils.CartItemCount;
import com.mobicart.renamed_package.utils.MyCommonView;

/**
 * This Activity class is used for showing cover flow images of a product.
 * 
 * @author mobicart
 */
public class CoverFlowExample extends Activity implements OnClickListener {

	private MyCommonView backBtn, cartBtn,cartEditBtn;
	private int currentProductPosition, order;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		currentProductPosition = getIntent().getIntExtra(
				"currentProductPosition", -1);
		order = getIntent().getIntExtra("currentOrder", -1);
		CoverFlow coverFlow;
		coverFlow = new CoverFlow(this);
		LayoutParams params = new LayoutParams(
				android.view.ViewGroup.LayoutParams.FILL_PARENT,
				android.view.ViewGroup.LayoutParams.WRAP_CONTENT);
		params.addRule(RelativeLayout.CENTER_IN_PARENT);
		coverFlow.setLayoutParams(params);
		ImageAdapter coverImageAdapter = new ImageAdapter(this,
				currentProductPosition, order);
		coverImageAdapter.createReflectedImages();
		coverFlow.setAdapter(coverImageAdapter);
		coverFlow.setSpacing(-15);
		coverFlow.setSelection(0, true);
		RelativeLayout layout = new RelativeLayout(this);
		layout.setLayoutParams(new LayoutParams(
				android.view.ViewGroup.LayoutParams.FILL_PARENT,
				android.view.ViewGroup.LayoutParams.FILL_PARENT));
		layout.addView(coverFlow);
		layout.setBackgroundColor(Color.parseColor("#000000"));
		setContentView(layout);
		cartEditBtn = TabHostAct.prepareCartEditButton(this);
		cartEditBtn.setVisibility(View.GONE);
		cartBtn = TabHostAct.prepareCartButton(this);
		cartBtn.setVisibility(View.VISIBLE);
		cartBtn.setText("" + CartItemCount.getCartCount(this));
		cartBtn.setBackgroundResource(R.drawable.cart_icon_selector);
		cartBtn.setOnClickListener(this);
		backBtn = TabHostAct.prepareSoftBackButton(this);
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.home.back", "Back"));
		backBtn.setOnClickListener(this);
	}

	@Override
	protected void onResume() {
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.home.back", "Back"));
		super.onResume();
	}

	@Override
	protected void onStart() {
		super.onStart();
	}

	@Override
	protected void onDestroy() {
		MobicartCommonData.isFromStart = "NotSplash";
		backBtn.setVisibility(View.VISIBLE);
		backBtn.setText(MobicartCommonData.keyValues.getString(
				"key.iphone.home.back", "Back"));
		super.onDestroy();
	}

	@Override
	public void onClick(View v) {
		if (v.getId() == R.id.universal_back_btn) {
			finish();
		}
		if (v.getId() == R.id.navigation_bar_cart_btn) {
			ParentActivityGroup parentActivity = (ParentActivityGroup) getParent();
			Intent cartAct = new Intent(this, CartAct.class);
			String backBtn = MobicartCommonData.keyValues.getString(
					"key.iphone.home.back", "Back");
			cartAct.putExtra("IsFrom", backBtn);
			cartAct.putExtra("ParentAct", "2");
			parentActivity.startChildActivity("CartAct", cartAct);
		}
	}

	@Override
	protected void onPause() {
		MobicartCommonData.isFromStart = "NotSplash";
		super.onPause();
	}
}
