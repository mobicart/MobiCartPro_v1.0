/**
 * 
 */
package com.mobicart.renamed_package.utils;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.lang.Thread.UncaughtExceptionHandler;
import java.text.SimpleDateFormat;
import java.util.Calendar;


/**
 * This class extends UncaughtExceptionHandler to log error details.
 * @author mobicart
 *
 */
public class DefaultExceptionHandler implements UncaughtExceptionHandler{
	
	private UncaughtExceptionHandler defaultUEH;
    private String localPath;
    private String ExceptionTime;
	private SimpleDateFormat dateFormater;


    public DefaultExceptionHandler (String localPath) {
        this.localPath = localPath;
		dateFormater = new SimpleDateFormat("MMMM-dd-yyyy+HH-mm");
		ExceptionTime=dateFormater.format(Calendar.getInstance()
					.getTime());
		this.defaultUEH = Thread.getDefaultUncaughtExceptionHandler();
    }
	
	@Override
	public void uncaughtException(Thread t, Throwable e) {
	        final Writer result = new StringWriter();
	        final PrintWriter printWriter = new PrintWriter(result);
	        e.printStackTrace(printWriter);
	        String stacktrace = result.toString();
	        printWriter.close();
	        File newfile=new File(localPath+"/"+ExceptionTime+"_ExcpetionLog.log");
	        try {
				newfile.createNewFile();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
	        if (localPath != null) {
	            writeToFile(stacktrace, newfile.getAbsolutePath());
	        }
	        defaultUEH.uncaughtException(t, e);
	}
	
	 private void writeToFile(String stacktrace, String filename) {
	        try {
	            BufferedWriter bos = new BufferedWriter(new FileWriter(
	                    filename));
	            bos.write(stacktrace);
	            bos.flush();
	            bos.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
}