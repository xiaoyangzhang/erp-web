package com.yihg.erp.utils;

import java.text.DecimalFormat;
import java.text.FieldPosition;
import java.text.Format;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GenerateSequenceUtil {
	/** .log */
    private static final Logger logger = LoggerFactory.getLogger(GenerateSequenceUtil.class);

    /** The FieldPosition. */
    private static final FieldPosition HELPER_POSITION = new FieldPosition(0);

    /** This Format for format the data to special format. */
    private final static Format dateFormat = new SimpleDateFormat("yyMMddHHmm");

    /** This Format for format the number to special format. */
    private final static NumberFormat numberFormat = new DecimalFormat("000");

    /** This int is the sequence number ,the default value is 0. */
    private static int seq = 0;

    private static final int MAX = 999;

    /**
     * 时间格式生成序列
     * @return String
     */
    public static synchronized String generateSequenceNo(String bizCode,String optType) {
        //Calendar rightNow = Calendar.getInstance();
    	Long curTime = System.currentTimeMillis();
        StringBuffer sb = new StringBuffer();
        sb.append(bizCode.toUpperCase());
        sb.append(optType.toUpperCase());
        dateFormat.format(curTime, sb, HELPER_POSITION);
        numberFormat.format(seq, sb, HELPER_POSITION);
        if (seq == MAX) {
            seq = 0;
        } else {
            seq++;
        }
        logger.info("THE SQUENCE IS :" + sb.toString());
        return sb.toString();
    }
    
    public static void main(String[] args){
    	for(int i=0;i<20;i++){
    		generateSequenceNo("YM","E");
    	}
    	/*logger.info("#############################");
    	for(int i=0;i<10;i++){
    		generateSequenceNo();
    	}*/
    }
}
