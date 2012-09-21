package com.mobicart.renamed_package.utils;

import android.content.Context;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.widget.RadioButton;

/**
 * This Class extends Radio Button to use customized fonts for Radio Button Text.
 * @author mobicart
 */
public class MyRadioButton extends RadioButton {

	private Context context;
	private String ttfName;

	/**
	 * @param context
	 * @param attrs
	 */
	public MyRadioButton(Context context, AttributeSet attrs) {
		super(context, attrs);

		this.context = context;
		this.ttfName =attrs.getAttributeValue(
				"http://schemas.android.com/apk/res/com.mobicart.renamed_package",
				"ttf_name");
		init();
	}

	private void init() {
		Typeface font = Typeface.createFromAsset(context.getAssets(), ttfName);
		setTypeface(font);
	}

	@Override
	public void setTypeface(Typeface tf) {
		super.setTypeface(tf);
	}
}
