package com.mobicart.renamed_package;

import java.util.ArrayList;

import android.app.Activity;
import android.app.ActivityGroup;
import android.app.LocalActivityManager;
import android.content.Intent;
import android.os.Bundle;
import android.view.Window;
import com.mobicart.android.model.MobicartCommonData;
import com.mobicart.renamed_package.constants.MobiCartConstantIds;
import com.zooz.android.lib.CheckoutActivity;

/**
 * This Activity is extending ActivityGroup which is used to manage the activity
 * stack.
 * 
 * @author mobicart
 * 
 */
public class ParentActivityGroup extends ActivityGroup {

	public ArrayList<String> childIdList;
	public static Boolean fromHome = false, fromAccount = false;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (childIdList == null) {
			childIdList = new ArrayList<String>();
		}
	}

	@Override
	public void finishFromChild(Activity child) {
		LocalActivityManager manager = getLocalActivityManager();
		int index = childIdList.size() - 1;
		if (index < 1) {
			finish();
			return;
		}
		manager.destroyActivity(childIdList.get(index), true);
		childIdList.remove(index);
		index--;
		String lastId = childIdList.get(index);
		try {
			Window newWindow = manager.getActivity(lastId).getWindow();
			setContentView(newWindow.getDecorView());
		} catch (NullPointerException e) {
		}
	}

	public void startChildActivity(String Id, Intent intent) {
		Window window = getLocalActivityManager().startActivity(Id,
				intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP));
		if (window != null) {
			childIdList.add(Id);
			setContentView(window.getDecorView());
		}
	}

	@Override
	public void onBackPressed() {
		int length = childIdList.size();
		if (length > 1) {
			try {
				Activity current = getLocalActivityManager().getActivity(
						childIdList.get(length - 1));
				current.finish();

			} catch (NullPointerException e) {
				this.getCurrentActivity().finish();
			}
		} else {
			if (fromHome == true && fromAccount == false) {
				MobicartCommonData.isFromStart = "";
				finish();
				return;
			}
			if (this.getCurrentActivity().getLocalClassName()
					.equalsIgnoreCase("HomeTabAct")) {
				MobicartCommonData.isFromStart = "";
				finish();
			} else
				return;
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == 1) {
			switch (resultCode) {
			case Activity.RESULT_OK:
				MobiCartConstantIds.ZOOZ_TRX_ID = data
						.getStringExtra(CheckoutActivity.ZOOZ_TRX_ID);
				break;
			case Activity.RESULT_CANCELED:
				if (data != null)
					if (!CheckoutAct.isBackPressed) {
						MobiCartConstantIds.ZOOZ_ERROR_CODE = data
								.getStringExtra(CheckoutActivity.ZOOZ_ERROR_CODE);
						MobiCartConstantIds.ZOOZ_ERROR_MSG = data
								.getStringExtra(CheckoutActivity.ZOOZ_ERROR_MSG);
					}
				break;
			default:
				break;
			}
		}
	}

	@Override
	protected void onUserLeaveHint() {
		ParentActivityGroup.this.finish();
	}

	@Override
	protected void onResume() {
		super.onResume();
	}

	@Override
	protected void onRestart() {
		super.onRestart();
	}
}
