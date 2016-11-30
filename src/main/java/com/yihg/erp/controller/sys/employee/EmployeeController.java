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
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.yihg.erp.aop.RequiresPermissions;
import com.yihg.erp.contant.PathPrefixConstant;
import com.yihg.erp.contant.PermissionConstants;
import com.yihg.erp.contant.SysConfigConstant;
import com.yihg.erp.controller.BaseController;
import com.yihg.erp.utils.WebUtils;
import com.yihg.mybatis.utility.PageBean;
import com.yimayhd.erpcenter.common.exception.ClientException;
import com.yimayhd.erpcenter.dal.product.constans.Constants;
import com.yimayhd.erpcenter.dal.sys.po.PlatformEmployeePo;
import com.yimayhd.erpcenter.dal.sys.po.PlatformOrgPo;
import com.yimayhd.erpcenter.dal.sys.po.PlatformRolePo;
import com.yimayhd.erpcenter.dal.sys.po.UserSession;
import com.yimayhd.erpcenter.facade.sys.query.PlatformEmployeePoDTO;
import com.yimayhd.erpcenter.facade.sys.query.UserSessionDTO;
import com.yimayhd.erpcenter.facade.sys.result.PlatformEmployeePoResult;
import com.yimayhd.erpcenter.facade.sys.result.PlatformOrgPoListResult;
import com.yimayhd.erpcenter.facade.sys.result.PlatformOrgPoResult;
import com.yimayhd.erpcenter.facade.sys.result.PlatformRolePoListResult;
import com.yimayhd.erpcenter.facade.sys.service.SysLoginFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformEmployeeFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformOrgFacade;
import com.yimayhd.erpcenter.facade.sys.service.SysPlatformRoleFacade;


@Controller
@RequestMapping("/employee")
public class EmployeeController extends BaseController{

	private static final Logger LOG = LoggerFactory
			.getLogger(EmployeeController.class);
	@Autowired
	private SysPlatformEmployeeFacade sysPlatformEmployeeFacade;
	@Autowired
	private SysPlatformOrgFacade sysPlatformOrgFacade;
	@Autowired
	private SysPlatformRoleFacade sysPlatformRoleFacade;
	@Autowired
	private SysLoginFacade sysLoginFacade;
	
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
		PlatformEmployeePoDTO dto = new PlatformEmployeePoDTO();
		dto.setPlatformEmployeePo(p);
		if (null == p.getStatus())
			p.setStatus(1);
		PageBean employeeList = sysPlatformEmployeeFacade.getEmployeeList(dto, p.getPage());
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
		PlatformOrgPoListResult orgTreeResult = sysPlatformOrgFacade.getOrgTree(bizId, null);
		List<PlatformOrgPo> orgTree = orgTreeResult.getPlatformOrgPos();
	
		for(PlatformOrgPo org : orgTree){
			//查询此组织机构下面是否有子菜单
			PlatformOrgPoListResult orgTreeResultChildre = sysPlatformOrgFacade.getOrgTree(bizId, org.getOrgId());
			List<PlatformOrgPo> orgTreeChildre = orgTreeResultChildre.getPlatformOrgPos();
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
			PlatformRolePoListResult rolesR = sysPlatformRoleFacade.getRoleList(bizId, Integer.valueOf(employeeId), 0);
			List<PlatformRolePo> roles = rolesR.getPlatformRolePos();
			PlatformEmployeePoResult poResult  = sysPlatformEmployeeFacade.findByEmployeeId(Integer.valueOf(employeeId));	
			empPo = poResult.getPlatformEmployeePo();
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
		PlatformOrgPoResult orgPoResult = sysPlatformOrgFacade.findByOrgId(orgId);	
		PlatformOrgPo orgPo = orgPoResult.getPlatformOrgPo();
		String orgName = "";		
		if(orgPo!=null){
			if( !orgPo.getParentId().equals(0)){
				PlatformOrgPoResult paPlatformOrgPoResult = sysPlatformOrgFacade.findByOrgId(orgPo.getParentId());
				PlatformOrgPo parOrgPo = paPlatformOrgPoResult.getPlatformOrgPo();
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
		PlatformRolePoListResult rolePoListResult = sysPlatformRoleFacade.getRoleList(bizId, null, 1);
		List<PlatformRolePo> roleList = rolePoListResult.getPlatformRolePos();
		modelMap.addAttribute("roleList", roleList);
		modelMap.addAttribute("bizId", bizId);
		modelMap.addAttribute("empPo", empPo);
		modelMap.addAttribute("orgId", orgId);
		modelMap.put("roleGroup", rolePoListResult.getRoleGroup());
		
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
			PlatformEmployeePoDTO dto = new PlatformEmployeePoDTO();
			dto.setPlatformEmployeePo(po);
			sysPlatformEmployeeFacade.saveEmployee(dto,WebUtils.getCurBizId(request));
		}catch (ClientException ce){
			return errorJson(ce.getMessage());
		}
		//return "redirect:listEmployee?orgId="+po.getOrgId();	
		return successJson();
	}
	
	
	@RequestMapping(value="delEmployee")
	@ResponseBody
	public String delEmp(Integer employeeId){
		return sysPlatformEmployeeFacade.deleteByEmployeeId(employeeId)> 0 ?successJson() :errorJson("操作失败");
	}
	
	@RequestMapping(value="resetPwd.htm")
	//@RequiresPermissions(PermissionConstants.SYS_USER)
	public String resetPassword(HttpServletRequest request,ModelMap model){
		Integer id = NumberUtils.toInt(request.getParameter("id"),0);
		PlatformEmployeePoResult usEmployeePoResult = sysPlatformEmployeeFacade.findByEmployeeId(id);
		PlatformEmployeePo user = usEmployeePoResult.getPlatformEmployeePo();
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
		PlatformEmployeePoDTO dto = new PlatformEmployeePoDTO();
		dto.setPlatformEmployeePo(po);
		return sysPlatformEmployeeFacade.updateEmployee(dto)> 0 ?successJson() :errorJson("操作失败");
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
		int result = sysPlatformEmployeeFacade.getEmployeeList(loginName,employeeId,bizId);
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
		sysPlatformEmployeeFacade.saveDataRight(list,employeeId);		
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
		List<Map<String, String>> list = sysPlatformEmployeeFacade.getOrgUserDateRightTree(WebUtils.getCurBizId(request),null,type,employeeId);
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
		
		List<Map<String, String>> list = sysPlatformEmployeeFacade.getOrgUserDateRightTree(WebUtils.getCurBizId(request),null,"multi",employeeId);
		model.addAttribute("orgUserJsonStr", JSON.toJSONString(list));
		model.addAttribute("employeeId", employeeId);
		return PathPrefixConstant.SYSTEM_EMPLOYEE_PREFIX+"org_user_data_right_tree";
	}
	
	@RequestMapping("orgUserDateRightTreeReverse.htm")
	public String orgUserDateRightTreeReverse(HttpServletRequest request,HttpServletResponse reponse,ModelMap model,Integer employeeId){
		
		List<Map<String, String>> list = sysPlatformEmployeeFacade.getOrgUserDateRightTreeByByViewUsrId(WebUtils.getCurBizId(request),null,"multi",employeeId);
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
				PlatformOrgPoResult platformOrgPoResult = sysPlatformOrgFacade.findByOrgId(orgPo.getParentId());
				PlatformOrgPo parOrgPo = platformOrgPoResult.getPlatformOrgPo();
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
			PlatformEmployeePoDTO dto = new PlatformEmployeePoDTO();
			dto.setPlatformEmployeePo(po);
			sysPlatformEmployeeFacade.updateEmployee(dto);
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
			UserSessionDTO userSessionDTO = new UserSessionDTO();
			userSessionDTO.setUserSession(userSession);
			sysLoginFacade.setUserSession(WebUtils.getSessionId(request), SysConfigConstant.SESSION_TIMEOUT_SECONDS, userSessionDTO);
			request.setAttribute("userSession", userSession);
		}catch (ClientException ce){
			return errorJson(ce.getMessage());
		}
		//return "redirect:listEmployee?orgId="+po.getOrgId();	
		return successJson();
	}
}
