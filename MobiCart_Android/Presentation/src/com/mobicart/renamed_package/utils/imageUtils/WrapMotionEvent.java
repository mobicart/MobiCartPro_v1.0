package com.mobicart.renamed_package.utils.imageUtils;

import android.view.MotionEvent;

/**
 * @author mobicart
 * 
 */
public class WrapMotionEvent {

	protected MotionEvent event;

	protected WrapMotionEvent(MotionEvent event) {

		this.event = event;
	}

	/**
	 * @param event
	 * @return
	 */
	static public WrapMotionEvent wrap(MotionEvent event) {
		try {
			return new EclairMotionEvent(event);
		} catch (VerifyError e) {
			return new WrapMotionEvent(event);
		}
	}

	/**
	 * @return
	 */
	public int getAction() {
		return event.getAction();
	}

	/**
	 * @return
	 */
	public float getX() {
		return event.getX();
	}

	/**
	 * @param pointerIndex
	 * @return
	 */
	public float getX(int pointerIndex) {
		verifyPointerIndex(pointerIndex);
		return getX();
	}

	/**
	 * @return
	 */
	public float getY() {
		return event.getY();
	}

	/**
	 * @param pointerIndex
	 * @return
	 */
	public float getY(int pointerIndex) {
		verifyPointerIndex(pointerIndex);
		return getY();
	}

	/**
	 * @return
	 */
	public int getPointerCount() {
		return 1;
	}

	/**
	 * @param pointerIndex
	 * @return
	 */
	public int getPointerId(int pointerIndex) {
		verifyPointerIndex(pointerIndex);
		return 0;
	}

	private void verifyPointerIndex(int pointerIndex) {
		if (pointerIndex > 0) {
			throw new IllegalArgumentException(
					"Invalid pointer index for Donut/Cupcake");
		}
	}

}
