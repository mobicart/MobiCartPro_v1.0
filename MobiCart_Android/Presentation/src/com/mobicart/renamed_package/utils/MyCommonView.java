package com.mobicart.renamed_package.utils;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.util.AttributeSet;
import android.widget.TextView;

import com.mobicart.android.model.MobicartCommonData;

/**
 * This Class extends TextView to use customized fonts for textviews.
 * 
 * @author mobicart
 * 
 */
@SuppressWarnings("unused")
public class MyCommonView extends TextView {

	private Context context;
	private String ttfName;
	private String TAG = getClass().getName();
	private ArrayList<Hyperlink> listOfLinks;
	private Pattern screenNamePattern = Pattern.compile("(@[a-zA-Z0-9_]+)");
	private Pattern hashTagsPattern = Pattern.compile("(#[a-zA-Z0-9_-]+)");
	private Pattern hyperLinksPattern = Pattern
			.compile("([Hh][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])");

	/**
	 * @param context
	 * @param attrs
	 */
	public MyCommonView(Context context, AttributeSet attrs) {
		super(context, attrs);
		this.context = context;
		this.ttfName = attrs
				.getAttributeValue(
						"http://schemas.android.com/apk/res/com.mobicart.renamed_package",
						"ttf_name");
		listOfLinks = new ArrayList<Hyperlink>();
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

	/**
	 * @param text
	 */
	public void gatherLinksForText(String text) {
		SpannableString linkableText = new SpannableString(text);
		gatherLinks(listOfLinks, linkableText, screenNamePattern);
		gatherLinks(listOfLinks, linkableText, hyperLinksPattern);
		for (int i = 0; i < listOfLinks.size(); i++) {
			Hyperlink linkSpec = listOfLinks.get(i);
			linkableText.setSpan(linkSpec.span, linkSpec.start, linkSpec.end,
					Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
			linkableText.setSpan(linkSpec.colorSpan, linkSpec.start,
					linkSpec.end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
		}
		setText(linkableText);
	}

	

	private final void gatherLinks(ArrayList<Hyperlink> links, Spannable s,
			Pattern pattern) {
		Matcher m = pattern.matcher(s);
		int start = 0;
		int end = 0;
		while (m.find()) {
			start = m.start();
			end = m.end();
			Hyperlink spec = new Hyperlink();
			spec.textSpan = s.subSequence(start, end);
			spec.colorSpan = new MyForegroundColorSpan(Color.parseColor("#"
					+ MobicartCommonData.colorSchemeObj.getHeaderColor()));
			spec.start = start;
			spec.end = end;
			links.add(spec);
		}
	}

	public class InternalURLSpan extends StyleSpan {
		public InternalURLSpan(int style) {
			super(style);
		}
	}

	public class MyForegroundColorSpan extends ForegroundColorSpan {
		public MyForegroundColorSpan(int color) {
			super(color);
		}
	}

	class Hyperlink {
		CharSequence textSpan;
		InternalURLSpan span;
		MyForegroundColorSpan colorSpan;
		int start;
		int end;
	}
}
