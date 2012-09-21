package com.mobicart.renamed_package;

import android.content.Intent;
import android.os.Bundle;

/**
 * This Activity is extending ParentActivityGroup and used to start first
 * activity of News Tab.
 * @author mobicart
 *
 */
public class NewsTabGroup extends ParentActivityGroup {
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    startChildActivity("NewsTabAct", new Intent(this,NewsTabAct.class));
	}
}
