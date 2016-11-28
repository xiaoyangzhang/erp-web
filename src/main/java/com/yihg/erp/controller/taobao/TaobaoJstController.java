package com.yihg.erp.controller.taobao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yihg.erp.controller.BaseController;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.product.api.TaoBaoStockService;
import com.yihg.supplier.constants.Constants;
import com.yihg.taobao.api.TaobaoOrderService;
import com.yihg.taobao.po.PlatTaobaoTrade;

@Controller
@RequestMapping(value = "/taobaoJst")
public class TaobaoJstController extends BaseController {
    
    @Autowired
    private TaobaoOrderService taobaoOrderService;
    
    @Autowired
    private TaoBaoStockService taoBaoStockService;
    
    @RequestMapping(value = "savePushTrade.do")
    @ResponseBody
    public String savePushTrade(String tid, String authClient, String response) {
        
        PageBean<PlatTaobaoTrade> pageBean = new PageBean<PlatTaobaoTrade>();
        pageBean.setPage(1);
        pageBean.setPageSize(Constants.PAGESIZE);
        
        pageBean = taobaoOrderService.savePushTrade(tid, authClient, response);
        
        List<PlatTaobaoTrade> pttList = pageBean.getResult();
        List<Map<String, String>> mapList = new ArrayList<Map<String, String>>();
        
     // 获取备注(扣除库存)
        for (PlatTaobaoTrade pt : pttList) {
            if (pt.getReceiveCount() !=null && new Integer(pt.getReceiveCount())>0){
                Map<String, String> map = new HashMap<String, String>();
                map.put("numIid", pt.getNumIid());//自编码、日期、数量, PlatTaobaoTradeOrderId
                map.put("depDate", pt.getDepartureDate());
                map.put("receiveCount", pt.getReceiveCount());
                map.put("receiveCount", pt.getReceiveCount());
                map.put("taobaoOrderId", pt.getId().toString());
                mapList.add(map);
            }
        }
        taoBaoStockService.updateProductStockByTaobao(mapList);
        
        return "OK";
    }
}
