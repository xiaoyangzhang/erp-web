package com.yihg.erp.controller.images.utils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

/**
 * 把日期(Date,Calendar)与String互转，可以指定格式
 *
 */

public class DateUtil 
{
	private static Logger log= Logger.getLogger(DateUtil.class);	
	private static final String FORMAT="yyyy-MM-dd HH:mm";

	public static Date str2Date(String str){
		return str2Date(str,null);
	}
     /**
      * 把字符串根据制定的格式转换成日期
      * @param str
      * @param format
      * @return
      */
				
	public static Date str2Date(String str,String format){
		if(str==null || str.length()==0){
			return null;
		}
		if(format==null || format.length()==0){
			format=FORMAT;
		}
		Date date=null;
		try{
			SimpleDateFormat sdf=new SimpleDateFormat(format);
			date=sdf.parse(str);
			
		}catch(Exception e){
			log.error("", e);
		}
		return date;

	}
    /**
     * 把字符串转换成calendar对象
     * @param str
     * @return
     */
	public static Calendar str2Calendar(String str){
		return str2Calendar(str,null);

	}
	public static Calendar str2Calendar(String str,String format){ 
				
		Date date=str2Date(str,format);
		if(date==null){
			return null;
		}
		Calendar c=Calendar.getInstance();
		c.setTime(date);
		
		return c;

	}

    
	/**
	 * 把calendar转换成字符串
	 * @param c
	 * @return
	 */
	public static String date2Str(Calendar c){//yyyy-MM-dd HH:mm:ss
		return date2Str(c,null);
	}
	public static String date2Str(Calendar c,String format){
		if(c==null){
			return null;
		}		
		return date2Str(c.getTime(),format);
	}

	public static String date2Str(Date d){//yyyy-MM-dd HH:mm:ss
		return date2Str(d,null);
	}
    /**
     *把日期转换成制定的格式
     * @param d
     * @param format
     * @return
     */
	public static String date2Str(Date d,String format){//yyyy-MM-dd HH:mm:ss
		if(d==null ){
			return null;
		}
		if(format==null || format.length()==0){
			format=FORMAT;
		}
		SimpleDateFormat sdf=new SimpleDateFormat(format);
		String s=sdf.format(d);
		return s;
	}
	/**
	 * 获得当前日期的字符串格式
	 * @param format
	 * @return
	 */
	public static String getCurDateStr(String format){
		Calendar c=Calendar.getInstance();
		return date2Str(c,format);
	}
	
	/**
	 * 获得从当前年到2011年的年份数组
	 * @return
	 */
	public static Integer[] getYears() {
		Calendar calendar=Calendar.getInstance();
		calendar.setTimeInMillis(System.currentTimeMillis());
		int year=calendar.get(Calendar.YEAR);
		int lowYear=2011;
		List<Integer> list=new ArrayList<Integer>();
		for(int i=year;i>=lowYear;i--){
			list.add(i);
		}
		
		return list.toArray(new Integer[1]);
	}
	
	
	/**
	 * 
	 * @return
	 */
	public static Integer getCurrtYear() {
		Calendar calendar=Calendar.getInstance();
		calendar.setTimeInMillis(System.currentTimeMillis());
		int year=calendar.get(Calendar.YEAR);
		return year;
		}


	/**
	 * 开始日期，结束日期.去到的是相差的天数
	 * @param enddate 日期具体到天不要到小时
	 * @param begindate日期具体到天不要到小时
	 * @return
	 */
	public   static   int   getIntervalDays(Date enddate, Date begindate)   {   
		//  SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
		//  enddate.get
        long  millisecond=enddate.getTime()-begindate.getTime();   
        int day   =(int)(millisecond /24L/60L / 60L /1000L);   
        return day;   
    }  
	
	/**
	 * 日期+分钟
	 * @param oldDate
	 * @param m
	 * @return
	 */
	public static Date addMinute(Date oldDate,Integer m){
		if(oldDate==null || m==null	){
			return null;
		}
		long ml=m*60*1000;
		long s=oldDate.getTime()+ml;
		Date d=new Date(s);
		return d;
	}
	public static List<Date> getMonthList(Calendar start,Calendar end){
		if(start==null || end==null	){
			return null;
		}
		return getMonthList(start.getTime(),end.getTime());
	}
	public static List<Date> getMonthList(Date start,Date end){
		if(start==null || end==null	){
			return null;
		}
		Calendar calendar=Calendar.getInstance();
		List<Date> list=new ArrayList<Date>();
		
		list.add(start);
		calendar.setTimeInMillis(start.getTime());
		int sm=calendar.get(Calendar.MARCH);
		int sy =calendar.get(Calendar.YEAR);
		calendar.setTimeInMillis(end.getTime());
		int em=calendar.get(Calendar.MARCH);
		int ey=calendar.get(Calendar.YEAR);
		if(sy>ey){
			return null;
		}
		if(sy==ey && sm>em){
			return null;
		}
		while(true){
			sm++;
			calendar.set(sy, sm, 1,0,0,0);
			//Date d=new Date(calendar.getTime().getTime()-1000);
			Date d=calendar.getTime();
			if(d.after(end)){
				break;
			}
			list.add(d);
		}
		
		list.add(end);
		
		return list;
	}
	
	public static void main(String[] args) {
		Calendar c1=Calendar.getInstance();
		c1.set(2012, 2, 15);
		
		Calendar c2=Calendar.getInstance();
		c2.set(2013, 1, 20);
		
		List<Date> list=DateUtil.getMonthList(c1, c2);
		for(Date d:list){
			System.out.println(DateUtil.date2Str(d));
		}
		
	}
	
}