package com.yihg.erp.contant;

import java.util.HashMap;
import java.util.Map;

public class OpenPlatformConstannt {
    /**
     * erp与接口中心【行程助手】推送参数.
     */
    public static final Map<String, String> openAPI_AssistantMap = new HashMap<String, String>();
    
    static {
//        openAPI_AssistantMap.put("Url", "http://localhost:9876/yihg-open-api/assistantGroup/");
                //openAPI_AssistantMap.put("Url", "http://open.lvdao100.com/assistantGroup/");
        openAPI_AssistantMap.put("Url", "http://172.16.1.164:8080/assistantGroup/");
        openAPI_AssistantMap.put("appKey", "57253556");
        openAPI_AssistantMap.put("secretKey", "d95tu574dec5d04aece19d76db4b376n");
        openAPI_AssistantMap.put("pushMethod", "toErpGroup.do");
    }
    
    /**
     * erp与接口中心【订单接口】推送参数
     */
    public static final Map<String, String> openAPI_OrderMap = new HashMap<String, String>();
    
    static {
        openAPI_OrderMap.put("Url", "http://localhost:9876/yihg-open-api/transferOrder/");
        // openAPI_AssistantMap.put("Url", "http://open.lvdao100.com/transferOrder/");
        openAPI_OrderMap.put("appKey", "57253556");
        openAPI_OrderMap.put("secretKey", "d95tu574dec5d04aece19d76db4b376n");
        openAPI_OrderMap.put("callMethod", "getOrder.do");
    }
    
    /**
     * 爱游产品系统接口 推送参数 【产品管理》产品列表】使用.
     */
    public static final Map<String, String> AIYOU_PRODUCT_APIMap = new HashMap<String, String>();
    
    static {
        AIYOU_PRODUCT_APIMap.put("Url", "http://121.41.173.162:30005/");
        AIYOU_PRODUCT_APIMap.put("appKey", "LVDAOERP");
        AIYOU_PRODUCT_APIMap.put("apiPath", "PubFunction/aiyouAPI.ashx");
    }
}
