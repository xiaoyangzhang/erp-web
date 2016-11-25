package com.yihg.erp.utils;


import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 访问工具类
 */
public class HttpUtil {
    
    private static Logger logger = LogManager.getLogger(HttpUtil.class);
    
    /**
     * 远程访问
     *
     * @param url 地址
     * @param map 参数
     * @return 远程数据
     */
    public static String RemoteAccess(String url, Map<String, String> map) {
        CloseableHttpClient closeableHttpClient = HttpClients.createDefault();
        
        HttpPost httpPost = new HttpPost(url);
        
        List<NameValuePair> nameValuePairList = new ArrayList<NameValuePair>();
        
        for (Map.Entry<String, String> mapEntry : map.entrySet()) {
            nameValuePairList.add(new BasicNameValuePair(mapEntry.getKey(), mapEntry.getValue()));
        }
        
        CloseableHttpResponse closeableHttpResponse = null;
        String response = "";
        try {
            httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairList));
            
            closeableHttpResponse = closeableHttpClient.execute(httpPost);
            
            HttpEntity httpEntity = closeableHttpResponse.getEntity();
            
            response = EntityUtils.toString(httpEntity);
            
        } catch (UnsupportedEncodingException e) {
            logger.error("UnsupportedEncodingException:" + e.getMessage());
        } catch (IOException e) {
            logger.error("IOException:" + e.getMessage());
        } finally {
            try {
                closeableHttpResponse.close();
            } catch (IOException e) {
                logger.error("IOException:" + e.getMessage());
            }
        }
        
        httpPost.abort();
        
        return response;
    }
}
