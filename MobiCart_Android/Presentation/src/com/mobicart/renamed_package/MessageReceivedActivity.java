package com.mobicart.renamed_package;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.widget.TextView;

/**
 * This Activity is used to display Notification after getting message from
 * server.
 * 
 * @author mobicart
 * 
 */
public class MessageReceivedActivity extends Activity {
	String message;
	Bundle extras;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		setContentView(R.layout.activity_result);
		super.onCreate(savedInstanceState);
	}
	@Override
	protected void onResume() {
		super.onResume();
		extras = getIntent().getExtras();
		if (extras != null) {
			message = extras.getString("payload");
			if (message != null && message.length() > 0) {
				TextView view = (TextView) findViewById(R.id.result);
				view.setText(message);
			}
		}
	}
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		Intent intent = new Intent(Intent.ACTION_MAIN);
		intent.addCategory(Intent.CATEGORY_HOME);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		this.startActivity(intent);
		this.finish();
		return true;
	}
}