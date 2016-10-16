package com.yihg.erp.controller.sys.employee;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.util.TypeUtils;
import com.yihg.supplier.api.SupplierService;
import com.yihg.supplier.constants.Constants;
import com.yihg.supplier.po.SupplierBankaccount;
import com.yihg.supplier.po.SupplierBill;
import com.yihg.supplier.po.SupplierInfo;
import com.yihg.supplier.vo.SupplierVO;
import com.yihg.sys.api.PlatformEmployeeService;
import com.yihg.sys.api.PlatformOrgService;
import com.yihg.sys.api.PlatformRoleService;
import com.yihg.sys.api.PlatformSessionService;
import com.yihg.sys.api.SysBizBankAccountService;
import com.yihg.sys.api.SysBizInfoService;
import com.yihg.basic.api.DicService;
import com.yihg.basic.contants.BasicConstants;
import com.yihg.basic.exception.ClientException;
import com.yihg.basic.po.DicInfo;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PathPrefixConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.contant.SysConfigConstant;
import com.yihg.erp.controller.BaseController;
import com.yihg.mybatis.utility.PageBean;
import com.yihg.operation.po.BookingSupplier;
import com.yihg.sys.po.PlatformEmployeePo;
import com.yihg.sys.po.PlatformMenuPo;
import com.yihg.sys.po.PlatformOrgPo;
import com.yihg.sys.po.PlatformRoleMenuLinkPo;
import com.yihg.sys.po.PlatformRolePo;
import com.yihg.sys.po.SysBizBankAccount;
import com.yihg.sys.po.SysBizInfo;
import com.yihg.sys.po.SysDataRight;
import com.yihg.sys.po.UserSession;
import com.yihg.erp.utils.ResultWebUtils;
import com.yihg.erp.utils.SysServiceSingleton;
import com.yihg.erp.utils.WebUtils;


@Controller
@RequestMapping("/employee")
public class EmployeeController extends BaseController{

	private static final Logger LOG = LoggerFactory
			.getLogger(EmployeeController.class);
	@Autowired
	private PlatformEmployeeService platformEmployeeService;
	@Autowired
	private PlatformOrgService orgService;
	
	@Autowired
	private PlatformRoleService platformRoleService;
	private SysBizBankAccountService bankAccountService;
	@Autowired
	private DicService dicService;
	@Autowired
	private SysBizInfoService bizInfoService;
	@Autowired
	private PlatformSessionService platformSessionService;
	
	@RequestMapping(value="listEmployee")
	@RequiresPermissions(PermissionConstants.SYS_USER)
    public String index(HttpServletRequest request,ModelMap modelMap,PlatformEmployeePo p){
		
		if(p.getPage()==null){
			p.setPage(1);
		}
		if(p.getPageSize()==null){
			p.setPageSize(Constants.PAGESIZE);
		}
		p.setBizId(WebUtils.getCurBizId(request));
		PageBean employeeList = platformEmployeeService.getEmployeeList(p, p.getPage());
		modelMap.addAttribute("empList", employeeList);
		modelMap.addAttribute("p",p);
        return PathPrefixConstant.SYSTEM_EMPLOYEE_PREFIX+"employee_index";

    }
	
	@RequestMapping(value="listtreeEmployee",method = RequestMethod.GET)
	@RequiresPermissions(PermissionConstants.SYS_USER)
    public String indextree(HttpServletRequest request,ModelMap modelMap){
		Integer bizId = WebUtils.getCurBizId(request);
		//查询组织机构树
		ArrayList<Map<Object, Object>> maps = new ArrayList<Map<Object,Object>>();
		List<PlatformOrgPo> orgTree = orgService.getOrgTree(bizId, null);
	
		for(PlatformOrgPo org : orgTree){
			//查询此组织机构下面是否有子菜单
			List<PlatformOrgPo> orgTreeChildre = orgService.getOrgTree(bizId, org.getOrgId());
			int child_count = orgTreeChildre.size();
			Map<Object, Object> map = new HashMap<Object, Object>();
			//封装一级
			map.put("id", org.getOrgId());
			map.put("pId", org.getParentId());
			map.put("name", org.getName());
		
			if(child_count>0)
			{
				map.put("open", "true");//是否展开
			}
			maps.add(map);
			
		}
		//JSONArray menuJosnStr = JSONArray.fromObject(maps);
		String menuJosnStr = JSON.toJSONString(maps);
		modelMap.put("orgJosnStr", menuJosnStr);
        return PathPrefixConstant.SYSTEM_EMPLOYEE_PREFIX+"employee_treeindex";
    }
	
	

	@RequestMapping(value="editEmployee")
	@RequiresPermissions(PermissionConstants.SYS_USER)
	public String editEmp(ModelMap modelMap,HttpServletRequest request,Integer employeeId,Integer orgId){
		Integer bizId = WebUtils.getCurBizId(request);
		PlatformEmployeePo empPo  = null;
		if(employeeId!=null){
			//查询用户关联的角色，回显角色数据
			List<PlatformRolePo> roles = platformRoleService.getRoleList(bizId, Integer.valueOf(employeeId), 0);
			empPo= platformEmployeeService.findByEmployeeId(Integer.valueOf(employeeId));	
			empPo.setBizId(bizId);
			modelMap.addAttribute("roles", roles);
			
			orgId = empPo.getOrgId();
		}else{
			empPo = new PlatformEmployeePo();
			empPo.setBizId(bizId);
			empPo.setOrgId(orgId);
			empPo.setGender(1);
			empPo.setStatus(1);
			empPo.setIsSuper(0);
		}
		PlatformOrgPo orgPo = orgService.findByOrgId(orgId);		
		String orgName = "";		
		if(orgPo!=null){
			if( !orgPo.getParentId().equals(0)){
				PlatformOrgPo parOrgPo = orgService.findByOrgId(orgPo.getParentId());
				orgName+=parOrgPo.getName()+"->";
			}
			orgName+=orgPo.getName();
		}
		
		
		if(StringUtils.isEmpty(orgName)){
			orgName = "无";
		}
		modelMap.addAttribute("orgName", orgName);
		//JSONArray menuJosnStr = JSONArray.fromObject(maps);
		//String orgJsonStr = JSON.toJSONString(maps);
		
		//角色列表
		List<PlatformRolePo> roleList = platformRoleService.getRoleList(bizId, null, 1);
		modelMap.addAttribute("roleList", roleList);
		modelMap.addAttribute("bizId", bizId);
		modelMap.addAttribute("empPo", empPo);
		modelMap.addAttribute("orgId", orgId);
		List<DicInfo> roleGroup = dicService.getListByTypeCode(BasicConstants.ROLE_GROUP,WebUtils.getCurBizId(request));
		modelMap.put("roleGroup", roleGroup);
		
		return PathPrefixConstant.SYSTEM_EMPLOYEE_PREFIX+"employee_edit";
	}
	
	@RequestMapping(value="saveEmployee")
	@ResponseBody
	public String saveEmp(HttpServletRequest request,PlatformEmployeePo po,String roles )
	{
		String[] roleIds = roles.split(",");
		List<String> roleIdsList=new ArrayList<String>();
		for (String string : roleIds) {
			if(StringUtils.isNotBlank(string)){
				roleIdsList.add(string);
			}
		}
		po.setRole(roleIdsList);
		System.out.println("kaokaokao");
		try {
			platformEmployeeService.saveEmployee(po,WebUtils.getCurBizId(request));
		}catch (ClientException ce){
			return errorJson(ce.getMessage());
		}
		//return "redirect:listEmployee?orgId="+po.getOrgId();	
		return successJson();
	}
	
	
	@RequestMapping(value="delEmployee")
	@ResponseBody
	public String delEmp(Integer employeeId){
		return platformEmployeeService.deleteByEmployeeId(employeeId)> 0 ?successJson() :errorJson("操作失败");
	}
	
	@RequestMapping(value="resetPwd.htm")
	//@RequiresPermissions(PermissionConstants.SYS_USER)
	public String resetPassword(HttpServletRequest request,ModelMap model){
		Integer id = NumberUtils.toInt(request.getParameter("id"),0);
		PlatformEmployeePo user = platformEmployeeService.findByEmployeeId(id);
		model.addAttribute("user", user);
		return PathPrefixConstant.SYSTEM_EMPLOYEE_PREFIX+"resetPassword";
	}
	
	/**
	 * 修改用户名和密码
	 * @param po
	 * @return
	 */
	@RequestMapping(value="updatePass")
	@ResponseBody
	public String updatePass(PlatformEmployeePo po){
		return platformEmployeeService.updateEmployee(po)> 0 ?successJson() :errorJson("操作失败");
	}
	/**
	 * 验证用户名唯一性
	 * @param request
	 * @param reponse
	 * @param loginName
	 * @param employeeId
	 * @return
	 */
	
	@ResponseBody
	@RequestMapping("/commons/valideteEmpName")
	public String valideteMenuName(
			String loginName, 
			Integer employeeId,
			HttpServletRequest request, HttpServletResponse response, Integer bizId){
		int result = platformEmployeeService.getEmployeeList(loginName,employeeId,bizId);
		if(result==0){
			return "true";
		}else{
			return "false";
		}
	}
	
	@RequestMapping("saveOrgUser.do")
	@ResponseBody
	public String saveOrgUser(HttpServletRequest request,HttpServletResponse reponse,String type,String userArr,Integer employeeId){
		//List<PlatformEmployeePo> employeeList = JSON.parseArray(userArr, PlatformEmployeePo.class);
		List<Map> list = JSON.parseArray(userArr, Map.class);
		platformEmployeeService.saveDataRight(list,employeeId);		
		return successJson();
		
	}
	
	/**
	 * 选择人员页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @param type 单选 single 多选multi
	 * @return
	 */
	@RequestMapping("userOrgDateRightTree.htm")
	public String orgUserDateRightTree(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,String type,Integer employeeId){	
		/*if(StringUtils.isBlank(type)){
			type = "single";
		}
		List<Map<String, String>> list = platformEmployeeService.getOrgUserDateRightTree(WebUtils.getCurBizId(request),null,type,employeeId);
		model.addAttribute("orgUserJsonStr", JSON.toJSONString(list));
		model.addAttribute("employeeId", employeeId);
		if(type.equals("single")){
			return "component/user/user_tree_single";
		}else{
			return "component/user/user_tree_multi";
		}*/
		return null;
	}
	
	
	/**
	 * 选择人员页面
	 * @param request
	 * @param reponse
	 * @param model
	 * @param type 单选 single 多选multi
	 * @return
	 */
	@RequestMapping("orgUserDateRightTree.htm")
	public String orgUserDateRightTree(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,Integer employeeId){
		
		List<Map<String, String>> list = platformEmployeeService.getOrgUserDateRightTree(WebUtils.getCurBizId(request),null,"multi",employeeId);
		model.addAttribute("orgUserJsonStr", JSON.toJSONString(list));
		model.addAttribute("employeeId", employeeId);
		return PathPrefixConstant.SYSTEM_EMPLOYEE_PREFIX+"org_user_data_right_tree";
	}
	
	@RequestMapping("orgUserDateRightTreeReverse.htm")
	public String orgUserDateRightTreeReverse(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,Integer employeeId){
		
		List<Map<String, String>> list = platformEmployeeService.getOrgUserDateRightTreeByByViewUsrId(WebUtils.getCurBizId(request),null,"multi",employeeId);
		model.addAttribute("orgUserJsonStr", JSON.toJSONString(list));
		model.addAttribute("employeeId", employeeId);
		return PathPrefixConstant.SYSTEM_EMPLOYEE_PREFIX+"user_data_right_tree_reverse";
	}
	
	@RequestMapping(value="editProfile.htm")
	public String editProfile(ModelMap modelMap,HttpServletRequest request){
		PlatformEmployeePo empPo  = WebUtils.getCurUser(request);
		
		PlatformOrgPo orgPo =  WebUtils.getCurOrgInfo(request);		
		String orgName = "";		
		if(orgPo!=null){
			if( !orgPo.getParentId().equals(0)){
				PlatformOrgPo parOrgPo = orgService.findByOrgId(orgPo.getParentId());
				orgName+=parOrgPo.getName()+"->";
			}
			orgName+=orgPo.getName();
		}
		
		if(StringUtils.isEmpty(orgName)){
			orgName = "无";
		}
		modelMap.addAttribute("orgName", orgName);
		modelMap.addAttribute("empPo", empPo);
		return PathPrefixConstant.SYSTEM_EMPLOYEE_PREFIX+"employee_profile";
	}
	
	@RequestMapping(value="saveProfile.do")
	@ResponseBody
	public String saveProfile(HttpServletRequest request,PlatformEmployeePo po){
		try {
			if(po.getPosition()==null){
				po.setPosition("");
			}
			if(po.getPhone()==null){
				po.setPhone("");
			}
			if(po.getEmail()==null){
				po.setEmail("");
			}
			if(po.getFax()==null){
				po.setFax("");
			}
			if(po.getQqCode()==null){
				po.setQqCode("");
			}
			platformEmployeeService.updateEmployee(po);
			//更新缓存里用户的档案信息
			UserSession userSession = WebUtils.getCurrentUserSession(request);
			userSession.setName(po.getName());
			PlatformEmployeePo sessionEmployeePo = userSession.getEmployeeInfo();
			sessionEmployeePo.setName(po.getName());
			sessionEmployeePo.setPosition(po.getPosition());
			sessionEmployeePo.setMobile(po.getMobile());
			sessionEmployeePo.setPhone(po.getPhone());
			sessionEmployeePo.setEmail(po.getEmail());
			sessionEmployeePo.setFax(po.getFax());
			sessionEmployeePo.setQqCode(po.getQqCode());
			sessionEmployeePo.setGender(po.getGender());		
			//更新缓存和session里的数据
			platformSessionService.setUserSession(WebUtils.getSessionId(request), SysConfigConstant.SESSION_TIMEOUT_SECONDS, userSession);
			request.setAttribute("userSession", userSession);
		}catch (ClientException ce){
			return errorJson(ce.getMessage());
		}
		//return "redirect:listEmployee?orgId="+po.getOrgId();	
		return successJson();
	}
}
