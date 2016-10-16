package com.yihg.erp.common;

import java.util.List;

import com.alibaba.dubbo.common.json.JSON;
import com.alibaba.dubbo.common.json.ParseException;
import com.alibaba.fastjson.JSONArray;

public class AiYouStringUtil {
	public static String getOrderListString() {

		String s = "[{\"adult_num\": 2,\"group_num\": \"20160112齐影（双11）\",\"child_num\": 0,\"product_name\": \"昆明大理丽江7天6晚跟团游 五星高品质 云南丽江旅游 含机票\",\"from_city\": \"天津\",\"group_id\": \"f9a92d2250ec66f70150f527f1a218c0\",\"opid\":\"b837964445f04af8ac9eb312e93fac84\",\"reseller_contact_name\": \"何冬平\",\"reseller_contact_mobile\": null},{\"adult_num\": 2,\"group_num\": \"20160112邝艳媚（双11）\",\"child_num\": 0,\"product_name\":\"昆明大理丽江7天6晚跟团游 五星高品质 云南丽江旅游 含机票\",\"from_city\": \"广州\",\"group_id\": \"f9a92d2250ec66f70150f68a72422abf\",\"opid\": \"b837964445f04af8ac9eb312e93fac84\",\"reseller_contact_name\": \"何冬平\",\"reseller_contact_mobile\": null}]";

		return s;
	}

	public static String getOrderString() {

		String s = "{\"supplier_tel\": \"63808175\",\"child_num\": 0,\"room_info\": \"1个标间\",\"memo\": \"2大 怡之爱 天津出发 1个标间\",\"supplier_name\": \"昆明顺行旅行社有限公司\",\"from_city\": \"天津\",\"product_name\": \"昆明大理丽江7天6晚跟团游 五星高品质 云南丽江旅游 含机票\",\"reseller_name\": \"云南爱游杨健\",\"reseller_contact_name\": \"何冬平\",\"supplier_contact_name\": \"何炼\",\"reseller_tel\": \"0871-63548045\",\"adult_num\": 2,\"group_num\": \"20160112齐影（双11）\",\"reseller_fax\": \"0871-63549381\",\"supplier_contact_mobile\": null,\"tourists\": [{\"tourist_name\": \"齐影\",\"tourist_id\": \"130683198808063020\",\"tourist_id_type\": \"idcard\",\"tourist_mobile\": \"\"},{\"tourist_name\": \"金磊\",\"tourist_id\": \"12011319860802001X\",\"tourist_id_type\": \"idcard\",\"tourist_mobile\": \"13116198123\"}],\"flight_info\": [\"01-18 19:25昆明长水机场--飞-00:35天津滨海机场T2降奥凯航空BK2880\",\"01-12 07:35天津滨海机场T2飞-13:25昆明长水机场--降奥凯航空BK2811\"],\"supplier_fax\": \"63808175\",\"reseller_contact_mobile\": null}";

		return s;
	}
	
	@SuppressWarnings("unused")
	public static void main(String[] args) throws ParseException {
		List<AiYouBean> aiYouBeans = JSONArray.parseArray(getOrderListString(),AiYouBean.class);
		
		AiYouBean aiYouBean = JSON.parse(getOrderString(),AiYouBean.class);
		
		System.out.println(0);
	}
}
