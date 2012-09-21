package com.mobicart.renamed_package;

import android.content.Intent;
import android.os.Bundle;

/**
 * This Activity is extending ParentActivityGroup and used to start first
 * activity of Account Tab.
 * 
 * @author mobicart
 * 
 */
public class AccountTabGroupAct extends ParentActivityGroup {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		startChildActivity("MyAccountTabAct", new Intent(this,
				MyAccountTabAct.class));
	}
}
