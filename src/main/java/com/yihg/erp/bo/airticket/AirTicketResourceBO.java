package com.yihg.erp.bo.airticket;


import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.yihg.erp.controller.airticket.ResourceController;
import com.yimayhd.erpcenter.common.util.DateUtils;
import com.yimayhd.erpcenter.dal.sales.client.airticket.po.AirTicketLeg;
import com.yimayhd.erpcenter.dal.sales.client.airticket.po.AirTicketResource;

public class AirTicketResourceBO {

	private static final Logger log = LoggerFactory.getLogger(ResourceController.class);
	private AirTicketResource po; 
	private List<AirTicketLeg> legList;
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	private SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	private SimpleDateFormat legFormat = new SimpleDateFormat("HH:mm");
	
	public AirTicketResourceBO(AirTicketResource po){
		this.po = po;
	}
	public AirTicketResource getPo(){
		return this.po;
	}
	
    public Integer getId() {
        return this.po.getId();
    }
    public Integer getBizId() {
        return this.po.getBizId();
    }

    public String getResourceNumber() {
        return this.po.getResourceNumber();
    }
    
    public String getStartDate(){
//    	return sdf.format(this.po.getStartDate());
    	return DateUtils.format(po.getStartDate(), "yyyy-MM-dd");
    }
    public String getEndDate(){
    	if (this.po.getEndDate()==null){return "";}
//    	return sdf.format(this.po.getEndDate());
    	return DateUtils.format(po.getEndDate(), "yyyy-MM-dd");
    }

    public Integer getLegSize(){
    	return this.legList.size();
    }
    
    public List<AirTicketLeg> getLegList(){
    	return this.legList;
    }
    
    public String getDepDate() {
        return sdf.format(this.po.getDepDate());
    }

    public String getDepCity(){
    	return this.po.getDepCity();
    }
    
    public Integer getTicketSupplierId() {
        return this.po.getTicketSupplierId();
    }

    public String getTicketSupplier() {
        return this.po.getTicketSupplier();
    }

    public String getTicketOrderNum() {
        return this.po.getTicketOrderNum();
    }

    public BigDecimal getPrice() {
        return this.po.getPrice();
    }
    public String getTotalPrice(){
    	if (this.po.getPrice()==null){return "N/A";}
    	if (this.po.getTotalNumber()==null){return "N/A";}
    	String totalPrice = this.po.getPrice().multiply(new BigDecimal(this.po.getTotalNumber())).toString();
    	return this.po.getPrice() + "/" + totalPrice;
    }
    public String getTotalBuyPrice(){
    	if (this.po.getBuyPrice()==null){return "N/A";}
    	if (this.po.getTotalNumber()==null){return "N/A";}
    	String totalPrice = this.po.getBuyPrice().multiply(new BigDecimal(this.po.getTotalNumber())).toString();
    	return this.po.getBuyPrice() + "/" + totalPrice;
    }
    public BigDecimal getAdvancedDeposit() {
        return this.po.getAdvancedDeposit();
    }

    public Integer getTotalNumber() {
        return this.po.getTotalNumber();
    }

    public String getOperatorName() {
    	if (this.po.getOperatorName()=="" || this.po.getOperatorName()==null){
    		return this.po.getCreaterName();
    	}
        return this.po.getOperatorName();
    }

    public String getUpdateTime() {
    	Date time = this.po.getUpdateTime();
    	if (time == null){
    		time = this.po.getAddTime();
    	}
    	if (time == null){return "";}
        return sdfTime.format(time);
    }

    public String getComment() {
        return this.po.getComment();
    }
    public String getEndIssueTime(){
//    	return sdfTime.format(this.po.getEndIssueTime());
    	return DateUtils.format(po.getEndIssueTime(), "yyyy-MM-dd");
    }

	public void setLegList(List<AirTicketLeg> legList) {
		this.legList = legList;
	}
	public String getLegToolTip(){
		if (this.legList == null){return "";}
		ArrayList<String> arrLeg = new ArrayList<String>();
		for (AirTicketLeg leg : this.legList){
			StringBuffer sb = new StringBuffer();
			sb.append(sdf.format(leg.getDepDate()));
			sb.append(" &nbsp; ").append(leg.getAirCode());
			sb.append(" &nbsp; ").append(leg.getDepCity()).append("-").append(leg.getArrCity());
			String depTime=(leg.getDepTime()==null)?"":legFormat.format(leg.getDepTime());
			String arrTime=(leg.getArrTime()==null)?"":legFormat.format(leg.getArrTime());
			sb.append(" &nbsp; ").append(depTime).append("-").append(arrTime);
			arrLeg.add(sb.toString());
		}
		return StringUtils.join(arrLeg, "<br/>");
	}
	public String getLegHtml() throws ParseException{
		if (this.legList == null){return "";}
		StringBuffer sb = new StringBuffer("<table class='air_ticket_leg'>");
		for(int i=0; i<this.legList.size(); i++){
			AirTicketLeg leg = this.legList.get(i);
			sb.append("<tr><td width='75'>").append(sdf.format(leg.getDepDate())).append("</td><td>");
			sb.append(leg.getAirCode()).append("</td><td>");
			sb.append(leg.getDepCity()).append("-").append(leg.getArrCity()).append("</td>");
			String depTime=(leg.getDepTime()==null)?"":legFormat.format(leg.getDepTime());
			String arrTime=(leg.getArrTime()==null)?"":legFormat.format(leg.getArrTime());
			sb.append("<td>").append(depTime).append("-").append(arrTime).append("</td></tr>");
		}
		sb.append("</table>");
		return sb.toString();
	}
}