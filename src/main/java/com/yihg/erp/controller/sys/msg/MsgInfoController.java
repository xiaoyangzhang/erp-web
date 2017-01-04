package com.yihg.erp.controller.sys.msg;

import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.socket.TextMessage;

import com.yihg.erp.controller.BaseController;
import com.yihg.erp.socket.SocketHandler;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.dal.sys.po.MsgInfo;
import com.yimayhd.erpcenter.dal.sys.po.MsgInfoDetail;
import com.yimayhd.erpcenter.dal.product.constans.Constants;
import com.yimayhd.erpcenter.facade.sys.service.SysMsgInfoFacade;


@Controller
@RequestMapping("/msgInfo")
public class MsgInfoController extends BaseController{


//    private final PlatformOrgService orgService;
//
//    private final PlatformEmployeeService platformEmployeeService;
//
//    private final MsgInfoService msgInfoService;
//
//    private final MsgInfoDetailService msgInfoDetailService;

    private final SocketHandler socketHandler;

    private final SysMsgInfoFacade sysMsgInfoFacade;

    @Autowired
    public MsgInfoController(SocketHandler socketHandler, SysMsgInfoFacade sysMsgInfoFacade) {
        this.socketHandler = socketHandler;
        this.sysMsgInfoFacade = sysMsgInfoFacade;
    }

    /**
     * 跳转消息发送页面
     */
    @RequestMapping(value = "showMsg.htm")
    public String showMsg(HttpServletRequest request, HttpServletResponse reponse, ModelMap model) {

        Integer bizId = WebUtils.getCurBizId(request);
        model.addAttribute("orgJsonStr", sysMsgInfoFacade.getComponentOrgTreeJsonStr(bizId));
        model.addAttribute("orgUserJsonStr",
        		sysMsgInfoFacade.getComponentOrgUserTreeJsonStr(bizId));

        return "sys/msg/send_msg";
    }

    /**
     *
     * @param request
     * @param orderId
     * @param title
     * @param info
     * @param ids
     * @return
     */
    @RequestMapping(value = "sendMsg.do")
    @ResponseBody
    public String sendMsg(HttpServletRequest request, Integer msgType, String title, String info,
            String ids, String names, Integer orderId) {

        // 保存消息
        MsgInfo mi = new MsgInfo();
        mi.setBizId(WebUtils.getCurBizId(request));
        mi.setMsgType(msgType);
        mi.setMsgTitle(title);
        mi.setMsgText(info);
        mi.setOperatorId(WebUtils.getCurUserId(request));
        mi.setOperatorName(WebUtils.getCurUser(request).getName());
        if (orderId != null) {
            mi.setOrderId(orderId);
        }

        Integer mid = sysMsgInfoFacade.saveMsg(mi, ids, names);
        // 推送消息给用户
        if (mid > 0) {
            String[] idss = ids.split(",");
            for (String str : idss) {
                socketHandler.sendMessageToUser(Integer.parseInt(str),
                        new TextMessage("有新消息！&" + orderId + "&" + msgType + "&" + mid));
            }
        } else {
            return errorJson("信息发送失败！");
        }

        return successJson();
    }

    @RequestMapping(value = "showMsgList.htm")
    public String showMsgList(Integer msgType, ModelMap model) throws ParseException {
        model.addAttribute("msgType", msgType);
        return "sys/msg/show_msg";
    }

    @RequestMapping(value = "showMsgListTable.htm")
    public String showMsgListTable(HttpServletRequest request, HttpServletResponse reponse,
            Integer pageSize, Integer page, ModelMap model, MsgInfo mi, String startTime,
            String endTime, Integer status) throws ParseException {

        PageBean<MsgInfo> pageBean = new PageBean<MsgInfo>();
        if (page == null) {
            pageBean.setPage(1);
        } else {
            pageBean.setPage(page);
        }
        if (pageSize == null) {
            pageBean.setPageSize(Constants.PAGESIZE);
        } else {
            pageBean.setPageSize(pageSize);
        }

        mi.setBizId(WebUtils.getCurBizId(request));
        mi.setUserId(WebUtils.getCurUserId(request));
        mi.setStatus(status);
        pageBean.setParameter(mi);

        Map<String, String> param = new HashMap<String, String>();

        if (StringUtils.isNotBlank(startTime) && StringUtils.isNotBlank(endTime)) {
            param.put("startTime", startTime + " 00:00:00");
            param.put("endTime", endTime + "23:59:59");
        }

        pageBean = sysMsgInfoFacade.findMsgInfoListPage(pageBean, param);

        model.addAttribute("pageBean", pageBean);
        return "sys/msg/show_msg_table";
    }

    @RequestMapping(value = "modifyStatus.do")
    @ResponseBody
    public String modifyStatus(HttpServletRequest request, Integer midId) {

        // 更新状态
        MsgInfoDetail mid = new MsgInfoDetail();
        mid.setId(midId);
        mid.setStatus(1);

        Integer modify = sysMsgInfoFacade.modifyStatus(mid);

        if (modify > 0) {
            return successJson();
        }

        return errorJson("更新错误");
    }

    @RequestMapping(value = "showMsgDetail.htm")
    public String showMsgDetail(HttpServletRequest request, ModelMap model, Integer mid) {
        Map<String, Object> param = new HashMap<String, Object>();

        param.put("bizId", WebUtils.getCurBizId(request));
        param.put("mid", mid);
        MsgInfo mi = sysMsgInfoFacade.findMsgByMid(param);

        model.addAttribute("msg", mi);
        
        
        return "sys/msg/show_msg_detail";
    }

    @RequestMapping(value = "showNoticeList.htm")
    public String showNoticeList() throws ParseException {
        return "sys/msg/show_notice";
    }

    @RequestMapping(value = "showNoticeListTable.htm")
    public String showNoticeListTable(HttpServletRequest request, HttpServletResponse reponse,
            Integer pageSize, Integer page, ModelMap model, MsgInfo mi, String startTime,
            String endTime) throws ParseException {

        PageBean<MsgInfo> pageBean = new PageBean<MsgInfo>();
        if (page == null) {
            pageBean.setPage(1);
        } else {
            pageBean.setPage(page);
        }
        if (pageSize == null) {
            pageBean.setPageSize(Constants.PAGESIZE);
        } else {
            pageBean.setPageSize(pageSize);
        }

        mi.setBizId(WebUtils.getCurBizId(request));
        mi.setOperatorId(WebUtils.getCurUserId(request));

        pageBean.setParameter(mi);

        Map<String, String> param = new HashMap<String, String>();

        if (StringUtils.isNotBlank(startTime) && StringUtils.isNotBlank(endTime)) {
            param.put("startTime", startTime + " 00:00:00");
            param.put("endTime", endTime + "23:59:59");
        }

        pageBean = sysMsgInfoFacade.findNoticeListPage(pageBean, param);

        model.addAttribute("pageBean", pageBean);
        return "sys/msg/show_notice_table";
    }


}
