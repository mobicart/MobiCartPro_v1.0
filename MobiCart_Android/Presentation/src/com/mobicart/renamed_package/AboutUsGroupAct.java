package com.mobicart.renamed_package;

import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;

/**
 * This Activity is extending ParentActivityGroup and used to start first
 * activity of AboutUs Tab.
 * 
 * @author mobicart
 * 
 */
public class AboutUsGroupAct extends ParentActivityGroup {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		startChildActivity("AboutUsAct", new Intent(this, AboutUsTabAct.class));
	}


	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		return true;
	}
}
