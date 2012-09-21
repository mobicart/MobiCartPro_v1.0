package com.mobicart.renamed_package;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

/**
 * This Activity is extending ParentActivityGroup and used to start first
 * activity of Home Tab.
 * 
 * @author mobicart
 * 
 */
public class HomeTabGroupAct extends ParentActivityGroup {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		View background = new View(this);
		background.setBackgroundResource(R.drawable.default_mobicart);
		startChildActivity("HomeTabAct", new Intent(this, HomeTabAct.class));
	}
}
