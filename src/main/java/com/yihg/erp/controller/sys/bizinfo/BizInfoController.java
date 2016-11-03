package com.yihg.erp.controller.sys.bizinfo;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.SysConfig;
import com.yihg.erp.utils.WebUtils;
import com.yimayhd.erpcenter.dal.basic.po.DicInfo;
import com.yimayhd.erpcenter.dal.sys.po.SysBizBankAccount;
import com.yimayhd.erpcenter.dal.sys.po.SysBizInfo;
import com.yimayhd.erpcenter.facade.sys.query.SysBizBankAccountDTO;
import com.yimayhd.erpcenter.facade.sys.query.SysBizInfoDTO;
import com.yimayhd.erpcenter.facade.sys.result.SysBizBankAccountListResult;
import com.yimayhd.erpcenter.facade.sys.result.SysBizBankAccountResult;
import com.yimayhd.erpcenter.facade.sys.result.SysBizInfoFacadeResult;
import com.yimayhd.erpcenter.facade.sys.service.SysBizBankAccountFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysBizInfoFacade;

@Controller
@RequestMapping("bizinfo")
public class BizInfoController extends BaseController{
	@Autowired
	private SysBizBankAccountFacade sysBizBankAccountFacade;
	
	@Autowired
	private SysBizInfoFacade bizInfoFacade;
	@Autowired
	private SysConfig config;
	@RequestMapping("getSysBankInfo.do")
	@ResponseBody
	public String getSysBankInfo(HttpServletRequest request,
			HttpServletResponse reponse,Integer id,ModelMap model){
		SysBizBankAccountResult bankInfoResult = sysBizBankAccountFacade.getBankInfo(id);
		SysBizBankAccount bankInfo = bankInfoResult.getSysBizBankAccount();
		model.addAttribute("bankList", bankInfoResult.getBankList());
		return JSON.toJSONString(bankInfo);
	}
	/**
	 * 配置商家银行账户信息和logo
	 * @param request
	 * @param reponse
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "configBizInfo")
	public String configEmployee(HttpServletRequest request,
			HttpServletResponse reponse, ModelMap model) {
		Integer bizId = WebUtils.getCurBizId(request);
		SysBizBankAccountListResult sysBankaccountListResult = sysBizBankAccountFacade.getListByBizId(bizId);
		List<SysBizBankAccount> sysBankaccountList = sysBankaccountListResult.getSysBizBankAccounts();
		SysBizInfoFacadeResult sysBizInfoResult = bizInfoFacade.selectByPrimaryKey(bizId);
		SysBizInfo sysBizInfo = sysBizInfoResult.getSysBizInfo();
		model.addAttribute("bizId", bizId);
		model.addAttribute("bankaccountList", sysBankaccountList);
		if (sysBizInfo.getLogo()!=null) {
			String logo = sysBizInfo.getLogo().split(",")[0];
			model.addAttribute("logo", logo);
		}
		List<DicInfo> bankList = sysBankaccountListResult.getBankList();
		model.addAttribute("bankList", bankList);
		model.addAttribute("config", config);
		return "sys/bizInfo/configBizInfo";
	}
	/**
	 * 保存商家logo
	 * @param request
	 * @param reponse
	 * @param arr 存储logo路径的json字符串
	 * @param bizId
	 * @return
	 */
	@RequestMapping("saveLogo.do")
	@ResponseBody
	public String saveLogo(HttpServletRequest request,
			HttpServletResponse reponse,String arr,Integer bizId){
		JSONArray jsonArr = JSON.parseArray(arr);
		SysBizInfo biz=new SysBizInfo();
		biz.setId(bizId);
		biz.setLogo(jsonArr.getJSONObject(0).getString("path"));
		SysBizInfoDTO dto = new SysBizInfoDTO();
		dto.setSysBizInfo(biz);
		bizInfoFacade.updateSysBizInfo(dto);
		return successJson();
	}
	/**
	 * 保存银行账户信息
	 * @param request
	 * @param reponse
	 * @param bankAccount
	 */
	@RequestMapping("saveBank.do")
	public String saveBank(HttpServletRequest request,
			HttpServletResponse reponse,SysBizBankAccount bankAccount){
		if(bankAccount.getId()==null){
		bankAccount.setBizId(WebUtils.getCurBizId(request));
		SysBizBankAccountDTO dto = new SysBizBankAccountDTO();
		dto.setSysBizBankAccount(bankAccount);
		sysBizBankAccountFacade.addSysBizBankAccount(dto);
		}
		else{
			SysBizBankAccountDTO dto = new SysBizBankAccountDTO();
			dto.setSysBizBankAccount(bankAccount);
			sysBizBankAccountFacade.updateSysBizBankAccount(dto);
		}
		return "redirect:configBizInfo";
	}
	/**
	 * 删除商家银行账户
	 * @param request
	 * @param reponse
	 * @param id 商家银行账户主键
	 * @return
	 */
	
	@RequestMapping("delBank.do")
	
	public String delBank(HttpServletRequest request,
			HttpServletResponse reponse,Integer id){
		sysBizBankAccountFacade.delBankAccount(id);
		return "redirect:configBizInfo";
	}
}
