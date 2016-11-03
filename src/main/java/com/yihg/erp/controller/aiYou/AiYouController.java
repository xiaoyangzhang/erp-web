package com.yihg.erp.controller.aiYou;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.yihg.erp.common.AiYouOpBillDetailBean;
import com.yihg.erp.common.BizSettingCommon;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.DateUtils;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.common.contants.BasicConstants;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.product.po.ProductInfo;
import com.yimayhd.erpcenter.dal.product.po.ProductRemark;
import com.yimayhd.erpcenter.dal.product.po.ProductRoute;
import com.yimayhd.erpcenter.dal.sales.client.constants.Constants;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.AiYouBean;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrder;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderGuest;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupOrderPrice;
import com.yimayhd.erpcenter.dal.sales.client.sales.po.GroupRoute;
import com.yimayhd.erpcenter.dal.sales.client.sales.vo.FitOrderVO;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.facade.basic.service.DicFacade;
import com.yimayhd.erpcenter.facade.sales.query.SaveFitOrderInfoDTO;
import com.yimayhd.erpcenter.facade.sales.query.ToImpAiYouOrderDTO;
import com.yimayhd.erpcenter.facade.sales.result.ListResultSupport;
import com.yimayhd.erpcenter.facade.sales.result.ToImpAiYouOrderResult;
import com.yimayhd.erpcenter.facade.sales.service.AiYouFacade;
import com.yimayhd.erpcenter.facade.sales.service.GroupOrderFacade;
import com.yimayhd.erpcenter.facade.sales.service.GroupOrderFacade_aiyou;

@Controller
@RequestMapping(value = "/aiyou")
public class AiYouController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(AiYouController.class);
    @Autowired
    private BizSettingCommon settingCommon;

    @Autowired
    private GroupOrderFacade groupOrderFacade;
    
    @Autowired
    private GroupOrderFacade_aiyou groupOrderFacadeAiYou;
    @Autowired
    private SysConfig config;
    
    @Autowired
    private DicFacade dicFacade;
    
    @Autowired
    private AiYouFacade aiYouFacade;

    /**
     * 获取爱游订单
     *
     * @param request
     * @param code      商家编码
     * @param port      平台来源
     * @param startDate 发团开始日期
     * @param endDate   发团结束日期
     * @param groupNum  团号
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "toAiYouOrderList.htm")
    public String toAiYouOrderList(HttpServletRequest request,
                                   String code,
                                   String port,
                                   String startDate,
                                   String endDate,
                                   String groupNum,
                                   Model model) throws Exception {

        if (code == null || "".equals(code)) { // 默认商家编码
            code = "KMLSLXS";
        }

        if (port == null || "".equals(port)) { // 默认平台来源
            port = "AY";
        }

        if (startDate == null || "".equals(startDate)) {
            startDate = DateUtils.getMonthFirstDay();
        }

        if (endDate == null || "".equals(endDate)) {
            endDate = DateUtils.getMonthFirstDay();
        }

        Integer bizId = WebUtils.getCurBizId(request);

        List<AiYouBean> aiyouOrderList = Collections.emptyList();
        ListResultSupport<AiYouBean> resultSupport = groupOrderFacadeAiYou.getAiYourOrders(code, port, startDate, endDate, groupNum, bizId);
        if(resultSupport!=null && resultSupport.isSuccess()){
            aiyouOrderList = resultSupport.getValues();
        }

        model.addAttribute("code", code);
        model.addAttribute("port", port);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("groupNum", groupNum);
        model.addAttribute("aiyouOrderList", aiyouOrderList);

        model.addAttribute("curUser", WebUtils.getCurUser(request));

        return "aiyou/orderList";
    }

    @RequestMapping(value = "/saveAiYouData")
    @ResponseBody
    public String saveAiYouData(HttpServletRequest request,
                                String code,
                                String port,
                                @RequestParam("bIds[]") String[] bIds,
                                Integer saleOperatorId,
                                String saleOperatorName,
                                Integer operatorId,
                                String operatorName,
                                Integer supplierId,
                                String supplierName,
                                Integer productBrandId,
                                String productBrandName,
                                Integer productId,
                                String productName) throws Exception {

        // 访问爱游系统 (yihg-aiyou-api[数据查询系统])
        CloseableHttpClient closeableHttpClient = HttpClients.createDefault();
        // 访问地址
        HttpPost httpPost = new HttpPost(Constants.AIYOU_API_URL + "/opBill/orderDetialList.do");
        // 访问参数
        List<NameValuePair> nameValuePairList = new
                ArrayList<NameValuePair>();
        nameValuePairList.add(new BasicNameValuePair("dbType", port));
        nameValuePairList.add(new BasicNameValuePair("code", code));
        for (String bId : bIds) {
            nameValuePairList.add(new BasicNameValuePair("bids", bId));
        }

        httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairList));

        CloseableHttpResponse closeableHttpResponse = closeableHttpClient.execute(httpPost);

        String orderString = "";
        try {
            HttpEntity httpEntity = closeableHttpResponse.getEntity();

            orderString = EntityUtils.toString(httpEntity);
        } finally {
            closeableHttpResponse.close();
        }

        // 商家ID
        Integer bizId = WebUtils.getCurBizId(request);
        Integer userId = WebUtils.getCurUserId(request);
        String userName = WebUtils.getCurUser(request).getName();
        long currentTime = System.currentTimeMillis();

        List<AiYouOpBillDetailBean> aiYouOpBillDetailBeanList = JSONArray.parseArray(orderString, AiYouOpBillDetailBean.class);

        ProductRemark productRemark = aiYouFacade.findProductRemarkByProductId(productId);
        ProductInfo productInfo = aiYouFacade.findProductInfoById(productId);
        List<ProductRoute> productRouteList = aiYouFacade.findProductRouteByProductId(productId);

        List<GroupRoute> groupRouteList = new ArrayList<GroupRoute>();
        for (ProductRoute productRoute : productRouteList) {
            GroupRoute groupRoute = new GroupRoute();
            groupRoute.setDayNum(productRoute.getDayNum());
            groupRoute.setBreakfast(productRoute.getBreakfast());
            groupRoute.setLunch(productRoute.getLunch());
            groupRoute.setSupper(productRoute.getSupper());
            groupRoute.setHotelId(productRoute.getHotelId());
            groupRoute.setHotelName(productRoute.getHotelName());
            groupRoute.setRouteDesp(productRoute.getRouteDesp());
            groupRoute.setRouteTip(productRoute.getRouteTip());
            groupRoute.setCreateTime(currentTime);

            groupRouteList.add(groupRoute);
        }

        List<GroupOrder> groupOrderList = new ArrayList<GroupOrder>();
        for (AiYouOpBillDetailBean aiYouOpBillDetailBean : aiYouOpBillDetailBeanList) {
            GroupOrder groupOrder = new GroupOrder();

            groupOrder.setBizId(bizId); // biz_id
            groupOrder.setOrderType(-1); // order_type 订单类型 为-1一地散
            groupOrder.setSupplierName(supplierName); // supplier_name
            groupOrder.setSupplierId(supplierId); // supplier_id
            groupOrder.setSupplierCode(aiYouOpBillDetailBean.getGroupNum()); // supplier_code
            groupOrder.setOperatorId(operatorId); // operator_id
            groupOrder.setOperatorName(operatorName); // operator_name
            groupOrder.setSaleOperatorId(saleOperatorId); // sale_operator_id
            groupOrder.setSaleOperatorName(saleOperatorName); // sale_operator_name
            groupOrder.setNumAdult(aiYouOpBillDetailBean.getAdultNum()); // num_adult
            groupOrder.setNumChild(aiYouOpBillDetailBean.getChildrenNum()); // num_child
            // num_guide
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date date = new Date(Long.parseLong(aiYouOpBillDetailBean.getStartDate()));
            groupOrder.setDepartureDate(sdf.format(date)); // departure_date

            groupOrder.setProductId(productId); // product_id
            groupOrder.setProductBrandId(productBrandId); // product_brand_id
            groupOrder.setProductBrandName(productBrandName); // product_brand_name
            groupOrder.setProductName(productName); // product_name
            groupOrder.setProductShortName(productInfo.getNameCity()); // product_short_name
            groupOrder.setReceiveMode(aiYouOpBillDetailBean.getGroupNum().substring(8)); // receive_mode
            groupOrder.setServiceStandard(productRemark.getServeLevel()); // service_standard
            groupOrder.setRemark(productRemark.getRemarkInfo()); // remark
            String memo = "";
            if (aiYouOpBillDetailBean.getMemo() != null) {
                memo += aiYouOpBillDetailBean.getMemo() + "\n";
            }
            memo += "爱游产品名：" + aiYouOpBillDetailBean.getProductName() + "\n";
            if (aiYouOpBillDetailBean.getShuttleInfo() != null) {
                List<HashMap> hashMapList = JSONArray.parseArray(aiYouOpBillDetailBean.getShuttleInfo(), HashMap.class);
                List list = new ArrayList();
                for (HashMap hashMap : hashMapList) {
                    list.add(hashMap.get("info"));
                }
                memo += "机票：" + com.alibaba.fastjson.JSON.toJSONString(list) + "\n";
            }
            if (aiYouOpBillDetailBean.getAcomInfo() != null) {
                memo += "用房：" + aiYouOpBillDetailBean.getAcomInfo() + "\n";
            }
            groupOrder.setRemarkInternal(memo); // remark_internal
            groupOrder.setCreatorId(userId); // creator_id
            groupOrder.setCreatorName(userName); // creator_name
            groupOrder.setCreateTime(currentTime); // create_time
            groupOrder.setState(1); // state
            groupOrder.setAiyouGroupId(aiYouOpBillDetailBean.getBid()); // aiyou_group_id

            // 保存订单信息表 group_order
            groupOrderList.add(groupOrder);

            List<GroupOrderGuest> groupOrderGuestList = new ArrayList<GroupOrderGuest>();
            for (int i = 0; i < aiYouOpBillDetailBean.getMembers().size(); i++) {
                GroupOrderGuest groupOrderGuest = new GroupOrderGuest();
                groupOrderGuest.setName(aiYouOpBillDetailBean.getMembers().get(i).getMname());
                groupOrderGuest.setCertificateNum(aiYouOpBillDetailBean.getMembers().get(i).getIdno());
                groupOrderGuest.setMobile(aiYouOpBillDetailBean.getMembers().get(i).getMobile());
                groupOrderGuest.setCertificateTypeId(aiYouFacade
                        .getDicInfoByTypeCodeAndDicCode(BasicConstants.GYXX_ZJLX, BasicConstants.GYXX_ZJLX_SFZ)
                        .getId());
                if ("adult".equals(aiYouOpBillDetailBean.getMembers().get(i).getMtype())) {
                    groupOrderGuest.setType(1);
                } else if ("child".equals(aiYouOpBillDetailBean.getMembers().get(i).getMtype())) {
                    groupOrderGuest.setType(2);
                }

                groupOrderGuest.setNativePlace(aiYouOpBillDetailBean.getMembers().get(i).getNativeplace());
                groupOrderGuest.setAge(aiYouOpBillDetailBean.getMembers().get(i).getAge());
                groupOrderGuest.setRemark("");
                
                groupOrderGuestList.add(groupOrderGuest);
            }
            // 保存订单客人信息表 group_order_guest
            groupOrder.setGroupOrderGuestList(groupOrderGuestList);

            List<GroupOrderPrice> groupOrderPriceList = new ArrayList<GroupOrderPrice>();
            GroupOrderPrice groupOrderPrice;
            if (aiYouOpBillDetailBean.getAdultNum() > 0) {
                groupOrderPrice = new GroupOrderPrice();
                groupOrderPrice.setMode(0);
                groupOrderPrice.setNumTimes(1.0);
                	
                DicInfo dicInfo = aiYouFacade.getDicInfoByTypeCodeAndDicCode(bizId, BasicConstants.GYXX_LYSFXM, BasicConstants.CR);
                groupOrderPrice.setItemId(dicInfo.getId());
                groupOrderPrice.setItemName(dicInfo.getValue());

                groupOrderPrice.setUnitPrice(aiYouOpBillDetailBean.getPrice());
                groupOrderPrice.setNumPerson(Double.parseDouble(aiYouOpBillDetailBean.getAdultNum().toString()));
                groupOrderPrice.setTotalPrice(groupOrderPrice.getUnitPrice() * groupOrderPrice.getNumTimes() * groupOrderPrice.getNumPerson());

                groupOrderPrice.setCreatorId(userId);
                groupOrderPrice.setCreatorName(userName);
                groupOrderPrice.setCreateTime(currentTime);

                groupOrderPriceList.add(groupOrderPrice);

                groupOrder.setTotal(new BigDecimal(groupOrderPrice.getTotalPrice()));

                if (aiYouOpBillDetailBean.getChildrenNum() != null && aiYouOpBillDetailBean.getChildrenNum() > 0) {
                    groupOrderPrice = new GroupOrderPrice();
                    groupOrderPrice.setMode(0);
                    groupOrderPrice.setNumTimes(1.0);
                    
                    dicInfo = aiYouFacade.getDicInfoByTypeCodeAndDicCode(bizId, BasicConstants.GYXX_LYSFXM, BasicConstants.ERT);
                    groupOrderPrice.setItemId(dicInfo.getId());
                    groupOrderPrice.setItemName(dicInfo.getValue());

                    groupOrderPrice.setUnitPrice(aiYouOpBillDetailBean.getChildPrice());
                    groupOrderPrice.setNumPerson(Double.parseDouble(aiYouOpBillDetailBean.getChildrenNum().toString()));
                    groupOrderPrice.setTotalPrice(groupOrderPrice.getUnitPrice() * groupOrderPrice.getNumTimes() * groupOrderPrice.getNumPerson());

                    groupOrderPrice.setCreatorId(userId);
                    groupOrderPrice.setCreatorName(userName);
                    groupOrderPrice.setCreateTime(currentTime);

                    groupOrderPriceList.add(groupOrderPrice);

                    groupOrder.setTotal(new BigDecimal(groupOrderPrice.getTotalPrice()).add(groupOrder.getTotal()));
                }

            }
            // 保存订单价格信息表 group_order_price
            groupOrder.setOrderPrices(groupOrderPriceList);

            // 保存订单行程信息表 group_route
            groupOrder.setGroupRouteList(groupRouteList);
        }
        httpPost.abort();

        Integer groupOrderId = groupOrderFacadeAiYou.saveAiYouDataToGroupOrder(groupOrderList);
        if (groupOrderId > 0) {
            return successJson("msg", "数据导入成功！");
        } else {
            return errorJson("数据导入失败！");
        }

    }

    @RequestMapping(value = "toImpAiYouOrder.htm")
    public String toImpAiYouOrder(HttpServletRequest request, Integer productId, String code, String date,
                                  String supplierCode, String aiyouId, Model model) throws Exception {
    	
    	PlatformEmployeePo curUser = WebUtils.getCurUser(request);
    	
    	ToImpAiYouOrderDTO dto = new ToImpAiYouOrderDTO();
    	dto.setAiyouId(aiyouId);
    	dto.setBizId(WebUtils.getCurBizId(request));
    	dto.setCode(supplierCode);
    	dto.setCurUser(curUser);
    	dto.setDate(date);
    	dto.setProductId(productId);
    	dto.setSupplierCode(supplierCode);
    	ToImpAiYouOrderResult result = aiYouFacade.toImpAiYouOrder(dto);
    	
        model.addAttribute("operType", 1);
        model.addAttribute("editType", true);
        model.addAttribute("config", config);
        model.addAttribute("supplierList", result.getSourceTypeList());
        
        model.addAttribute("curUser", curUser);
        model.addAttribute("allowNum", result.getCount()); // 库存
        model.addAttribute("productId", productId);

        model.addAttribute("zjlxList", result.getZjlxList());

        model.addAttribute("vo", result.getFitOrderVO());
        model.addAttribute("jdxjList", result.getJdxjList());
        model.addAttribute("jtfsList", result.getJtfsList());

        model.addAttribute("sourceTypeList", result.getSourceTypeList());
        model.addAttribute("allProvince", result.getAllProvince());
        model.addAttribute("lysfxmList", result.getLysfxmList());
        return "aiyou/fitOrderInfo";
    }

    @RequestMapping(value = "saveFitOrderInfo.do", method = RequestMethod.POST)
    @ResponseBody
    public String saveFitOrderInfo(HttpServletRequest request, FitOrderVO fitOrderVO) throws ParseException {
        
    	SaveFitOrderInfoDTO dto = new SaveFitOrderInfoDTO();
    	dto.setBizCode(settingCommon.getMyBizCode(request));
    	dto.setBizId(WebUtils.getCurBizId(request));
    	dto.setEmployeeId(WebUtils.getCurUserId(request));
    	dto.setEmployeeName(WebUtils.getCurUser(request).getName());
    	dto.setFitOrderVO(fitOrderVO);
    	Integer orderId = aiYouFacade.saveFitOrderInfo(dto);
        return successJson("orderId", orderId + "");
    }

    /**
     * 根据产品ID和日期获取库存
     *
     * @param date
     * @return
     * @throws ParseException
     */
    @RequestMapping(value = "getStockByProductId.do")
    @ResponseBody
    public String getStockByProductId(Integer productId, String date) throws ParseException {
        Integer count = aiYouFacade.getRestCountByProductIdAndDate(productId,
                new SimpleDateFormat("yyyy-MM-dd").parse(date));
        return successJson("count", count.toString());
    }

    @RequestMapping(value = "getProductList.do", method = RequestMethod.GET)
    @ResponseBody
    public String getProductList(HttpServletRequest request, HttpServletResponse reponse, String name, String date)
            throws UnsupportedEncodingException {
        HashMap<String, Object> json = new HashMap<String, Object>();
        if (name == null) {
            name = "";
        }
        name = URLDecoder.decode(name, "UTF-8");

        List<ProductInfo> prodList = aiYouFacade.searchProductByNameAndDate(WebUtils.getCurBizId(request), name, date);

        ArrayList<HashMap<String, String>> result = new ArrayList<HashMap<String, String>>();
        for (ProductInfo p : prodList) {
            HashMap<String, String> prodMap = new HashMap<String, String>();
            prodMap.put("label", p.getBrandName() + p.getNameCity());
            prodMap.put("value", p.getId().toString());
            result.add(prodMap);
        }

        json.put("result", result);
        json.put("success", "true");
        return JSONArray.toJSONString(json);
    }

    

}
