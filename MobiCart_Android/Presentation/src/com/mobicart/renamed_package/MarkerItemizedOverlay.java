package com.mobicart.renamed_package;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.widget.Toast;

import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.OverlayItem;

/**
 * This Class is using ItemizedOverlay to add marker on MapView.
 * 
 * @author mobicart
 * 
 */
public class MarkerItemizedOverlay extends ItemizedOverlay<OverlayItem> {

	private ArrayList<OverlayItem> mOverlays = new ArrayList<OverlayItem>();
	private String address;
	private Context mContext;

	public MarkerItemizedOverlay(Drawable defaultMarker, Context context,
			String cAddress) {
		super(boundCenterBottom(defaultMarker));
		this.address = cAddress;
		this.mContext = context;
	}

	/**
	 * This Method overlay is added to list.
	 * 
	 * @param overlay
	 */
	public void addOverlay(OverlayItem overlay) {
		mOverlays.add(overlay);
		populate();
	}

	@Override
	protected OverlayItem createItem(int i) {
		return mOverlays.get(i);
	}

	@Override
	public int size() {
		return mOverlays.size();
	}

	@Override
	protected boolean onTap(int index) {
		Toast.makeText(mContext, address, Toast.LENGTH_LONG).show();
		return super.onTap(index);
	}
}
