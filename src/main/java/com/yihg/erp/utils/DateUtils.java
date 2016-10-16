package com.yihg.erp.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtils {
	public static String format(Date date){
		if(date == null){
			return "";
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd") ;
		return sdf.format(date) ;
	}
	
	public static String format(Date date,String pattern){
		if(date == null || pattern == null){
			return "";
		}
		SimpleDateFormat sdf = new SimpleDateFormat(pattern) ;
		return sdf.format(date) ;
	}
	
	/**
	 * 获取当前月第一天
	 * @return
	 */
	public static String getMonthFirstDay(){
	    Calendar c = Calendar.getInstance();    
	    c.add(Calendar.MONTH, 0);
	    c.set(Calendar.DAY_OF_MONTH,1);//设置为1号,当前日期既为本月第一天 
	    String first = DateUtils.format(c.getTime());
	    return first;
	}
	
	/**
	 * 获取当前月最后一天
	 * @return
	 */
	public static String getMonthLastDay(){
		Calendar ca = Calendar.getInstance();    
        ca.set(Calendar.DAY_OF_MONTH, ca.getActualMaximum(Calendar.DAY_OF_MONTH));  
        String last = DateUtils.format(ca.getTime());
        return last;
	}
	
	public static Date fmt(String str,String pattern){
		SimpleDateFormat sdf = new SimpleDateFormat(pattern) ;
		Date date= null;
		try {
			date =  sdf.parse(str) ;
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}
	/**
	 * 获取减去几小时后的时间
	 * @param date
	 * @param t
	 * @return
	 */
	public static Date getDateAgoByHour(Date date,Integer h){
		long s = date.getTime()-(h * 60 * 60 * 1000);
		return new Date(s);
	}
	
	public static void main(String[] args) {
		System.out.println(getDateAgoByHour(new Date(),24));
		System.out.println(new Date());
	}
	
	
}
