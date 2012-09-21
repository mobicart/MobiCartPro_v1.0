package com.mobicart.renamed_package;

import android.content.Intent;
import android.os.Bundle;

/**
 * @author mobicart
 *
 */
public class MoreTabGroupAct extends ParentActivityGroup {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		startChildActivity("MoreTabAct", new Intent(this, MoreTabAct.class));
	}
}
